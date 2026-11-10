FROM ghcr.io/huggingface/text-embeddings-inference:cpu-1.9.4@sha256:2538ea1c9640d3763b15af668039d24172d063b42337b0c27796fc2be180c78d

ARG MODEL_REVISION=5617a9f61b028005a4858fdac845db406aefb181
ADD --chmod=0444 --checksum=sha256:b5e0ce3470abf5ef3831aa1bd5553b486803e83251590ab7ff35a117cf6aad38 https://huggingface.co/BAAI/bge-m3/resolve/${MODEL_REVISION}/pytorch_model.bin /model/pytorch_model.bin
ADD --chmod=0444 --checksum=sha256:21106b6d7dab2952c1d496fb21d5dc9db75c28ed361a05f5020bbba27810dd08 https://huggingface.co/BAAI/bge-m3/resolve/${MODEL_REVISION}/tokenizer.json /model/tokenizer.json
ADD --chmod=0444 https://huggingface.co/BAAI/bge-m3/resolve/${MODEL_REVISION}/config.json /model/config.json
ADD --chmod=0444 https://huggingface.co/BAAI/bge-m3/resolve/${MODEL_REVISION}/tokenizer_config.json /model/tokenizer_config.json
ADD --chmod=0444 https://huggingface.co/BAAI/bge-m3/resolve/${MODEL_REVISION}/special_tokens_map.json /model/special_tokens_map.json
ADD --chmod=0444 https://huggingface.co/BAAI/bge-m3/resolve/${MODEL_REVISION}/1_Pooling/config.json /model/1_Pooling/config.json

# Honcho also needs these fixed tokenizer tables for offline startup.
ADD --chmod=0444 --checksum=sha256:446a9538cb6c348e3516120d7c08b09f57c36495e2acfffe59a5bf8b0cfb1a2d https://openaipublic.blob.core.windows.net/encodings/o200k_base.tiktoken /tokenizers/fb374d419588a4632f3f557e76b4b70aebbca790
ADD --chmod=0444 --checksum=sha256:223921b76ee99bde995b7ff738513eef100fb51d18c93597a113bcffe865b2a7 https://openaipublic.blob.core.windows.net/encodings/cl100k_base.tiktoken /tokenizers/9b5ad71b2ce5302211f9c61530b329a4922fc6a4
RUN chmod 0555 /model /model/1_Pooling /tokenizers

ENV MODEL_ID=/model HF_HUB_OFFLINE=1
LABEL org.opencontainers.image.description="TEI CPU with pinned BGE-M3 weights for household Honcho memory"
