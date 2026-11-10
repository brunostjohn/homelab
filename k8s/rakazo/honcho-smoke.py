"""Exercise local memory with synthetic facts; no household content or credentials are printed.

Run with HONCHO_URL and HONCHO_TOKEN_DIR pointing to the operator's private files.
Use seed, restart the pods, then verify to check durability and remove the test facts.
"""
import json
import os
from pathlib import Path
import sys
import time
import urllib.error
import urllib.request
import uuid

BASE = os.environ.get("HONCHO_URL", "http://127.0.0.1:18000").rstrip("/")
TOKENS = Path(os.environ["HONCHO_TOKEN_DIR"])
STATE = TOKENS / "honcho-smoke-state.json"
WORKSPACES = {
    "personal": "rakazo-13f3358a0d97b2ec15bab8f9dcbb4ff2",
    "family": "rakazo-2bad838e-461a-4d4b-9833-44b81b39cb4d",
}


def request(person, path, data=None, method=None, expected=(200, 201, 204)):
    token = (TOKENS / ("honcho-" + person + ".jwt")).read_text().strip() if person else "invalid"
    req = urllib.request.Request(
        BASE + path, json.dumps(data).encode() if data is not None else None,
        headers={"Authorization": "Bearer " + token, "Content-Type": "application/json"},
        method=method,
    )
    try:
        with urllib.request.urlopen(req, timeout=120) as response:
            status, body = response.status, response.read()
    except urllib.error.HTTPError as error:
        status, body = error.code, error.read()
    assert status in expected, f"{method or ('POST' if data is not None else 'GET')} {path}: HTTP {status}: {body[:400]!r}"
    return json.loads(body) if body else None


def query(person, peer):
    return request(person, f"/v3/workspaces/{WORKSPACES[person]}/conclusions/query", {
        "query": "Where is the spare key kept?", "top_k": 5,
        "filters": {"observer_id": peer, "observed_id": peer},
    })


assert sys.argv[1:] in (["seed"], ["verify"])
if sys.argv[1] == "seed":
    state = json.loads(STATE.read_text()) if STATE.exists() else {"peer": "deployment-check-" + uuid.uuid4().hex, "facts": {}}
    peer = state["peer"]
    for person, place in (("personal", "blue toolbox"), ("family", "green cupboard")):
        workspace = WORKSPACES[person]
        request(person, "/v3/workspaces", {"id": workspace})
        request(person, f"/v3/workspaces/{workspace}/peers", {"id": peer})
        fact = "Synthetic deployment test: the spare brass key is kept in the " + place + "."
        if person not in state["facts"]:
            request(person, f"/v3/workspaces/{workspace}/conclusions", {
                "conclusions": [{"content": fact, "observer_id": peer, "observed_id": peer}],
            })
            state["facts"][person] = fact
            STATE.write_text(json.dumps(state))
        assert state["facts"][person] == fact
        started = time.monotonic()
        result = query(person, peer)
        assert any(x["content"] == fact for x in result), "Saved fact was not recalled"
        assert all(x["content"] == fact for x in result), "Unexpected cross-space memory"
        print(person + " save/semantic recall passed in " + str(round(time.monotonic() - started, 2)) + "s")
        other = "family" if person == "personal" else "personal"
        request(person, f"/v3/workspaces/{WORKSPACES[other]}/conclusions/query", {
            "query": "spare key", "top_k": 5,
        }, expected=(401, 403))
        request(person, "/v3/workspaces/list?size=1", {}, expected=(401, 403))
        answer = request(person, f"/v3/workspaces/{workspace}/peers/{peer}/chat", {
            "query": "Where is the spare brass key kept?", "target": peer,
            "reasoning_level": "low", "stream": False,
        })
        assert place in answer.get("content", "").lower(), "Reasoning did not recall the saved fact"
        print(person + " subscription-backed memory reasoning passed")
    request(None, "/v3/workspaces/list?size=1", {}, expected=(401, 403))
    print("Workspace isolation and invalid-token rejection passed; synthetic facts retained for restart check")
else:
    state = json.loads(STATE.read_text())
    peer = state["peer"]
    for person, fact in state["facts"].items():
        prefix = f"/v3/workspaces/{WORKSPACES[person]}/conclusions"
        result = query(person, peer)
        assert any(x["content"] == fact for x in result), "Fact did not survive restart"
        for item in result:
            assert item["content"] == fact and item["observer_id"] == peer
            request(person, prefix + "/" + item["id"], method="DELETE")
        assert query(person, peer) == [], "Deleted fact is still recalled"
        updated = fact.replace("spare brass key", "replacement silver key")
        request(person, prefix, {"conclusions": [{"content": updated, "observer_id": peer, "observed_id": peer}]})
        result = query(person, peer)
        assert any(x["content"] == updated for x in result), "Replacement fact was not recalled"
        for item in result:
            assert item["content"] == updated and item["observer_id"] == peer
            request(person, prefix + "/" + item["id"], method="DELETE")
        assert query(person, peer) == [], "Test cleanup failed"
        print(person + " restart persistence, replace and forget passed")
    STATE.unlink()
    print("All synthetic memory facts removed")
