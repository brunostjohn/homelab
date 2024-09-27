import { getMessageFromExactMatchOrGroup } from "./commons";
import { fallbackPairs, subtitles, titles } from "./messages";

export const getMessage = (status: string) => {
	const title = getTitle(status);
	const subtitle = getSubtitle(status);

	if (!title || !subtitle) return getRandomPair();

	return { title, subtitle };
};

export const getSubtitle = (status: string) => getMessageFromExactMatchOrGroup(status, subtitles);

export const getTitle = (status: string) => getMessageFromExactMatchOrGroup(status, titles);

export const getRandomPair = () => fallbackPairs[Math.floor(Math.random() * fallbackPairs.length)];
