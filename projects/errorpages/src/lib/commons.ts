export const getMessageFromExactMatchOrGroup = (
	status: string,
	groups: { [key: string]: string[] }
) => {
	const exactMatch = Object.keys(groups).find((key) => key === status);
	if (exactMatch) return randomMessage(groups[exactMatch])!;

	const lastGenericMatch = Object.keys(groups).find(
		(key) => status.startsWith(key.slice(0, 1)) && key.endsWith("x") && !key.endsWith("xx")
	);
	if (lastGenericMatch) return randomMessage(groups[lastGenericMatch])!;

	const lastTwoGenericMatch = Object.keys(groups).find(
		(key) => key.endsWith("xx") && status.startsWith(key.at(0)!)
	);
	if (!lastTwoGenericMatch) return undefined;

	return randomMessage(groups[lastTwoGenericMatch]);
};

export const randomMessage = (group: string[]) => group[Math.floor(Math.random() * group.length)];
