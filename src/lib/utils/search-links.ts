import { Vocabulary, VocabularyWithLinks } from '@/lib/types';

/**
 * 일본어 단어로 유튜브 검색 URL 생성
 * 검색어: "단어 使い方" (사용법)
 */
export function getYoutubeSearchUrl(word: string): string {
  const query = encodeURIComponent(`${word} 使い方`);
  return `https://www.youtube.com/results?search_query=${query}`;
}

/**
 * 일본어 단어로 구글 검색 URL 생성
 * 검색어: "단어 例文" (예문)
 */
export function getGoogleSearchUrl(word: string): string {
  const query = encodeURIComponent(`${word} 例文`);
  return `https://www.google.com/search?q=${query}`;
}

/**
 * Vocabulary에 검색 링크 추가
 */
export function addSearchLinks(vocab: Vocabulary): VocabularyWithLinks {
  const searchWord = vocab.kanji || vocab.furigana;
  return {
    ...vocab,
    youtube_url: getYoutubeSearchUrl(searchWord),
    google_url: getGoogleSearchUrl(searchWord),
  };
}

/**
 * Vocabulary 배열에 검색 링크 일괄 추가
 */
export function addSearchLinksToList(vocabList: Vocabulary[]): VocabularyWithLinks[] {
  return vocabList.map(addSearchLinks);
}
