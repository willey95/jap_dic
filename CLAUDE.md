# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

일본어 학습 웹 애플리케이션. 사전, 듣기, 말하기, 쓰기, 한자, 맥락 이해 기능을 제공합니다.

## Tech Stack

- **Framework**: Next.js 14+ (App Router)
- **Language**: TypeScript
- **Styling**: Tailwind CSS + shadcn/ui
- **Database**: Supabase (PostgreSQL)
- **Auth**: Supabase Auth
- **Storage**: Supabase Storage (오디오 파일)
- **Deployment**: Vercel

## Commands

```bash
# 개발 서버 실행
npm run dev

# 빌드
npm run build

# 린트
npm run lint

# 타입 체크
npx tsc --noEmit
```

## Architecture

### 라우팅 구조 (App Router)
- `app/(auth)/` - 로그인/회원가입 페이지
- `app/(dashboard)/` - 메인 학습 기능 페이지들 (dictionary, listening, speaking, writing, kanji, context)
- `app/api/` - API 라우트 (vocabulary, kanji, progress, speech, ai)

### 주요 디렉토리
- `components/ui/` - shadcn/ui 컴포넌트
- `components/{feature}/` - 기능별 컴포넌트 (dictionary, listening, speaking, writing, kanji, context)
- `lib/supabase/` - Supabase 클라이언트 및 쿼리
- `lib/types/` - TypeScript 타입 정의
- `lib/hooks/` - 커스텀 훅

### 데이터베이스 테이블
- `profiles` - 사용자 프로필
- `vocabulary` - 단어 데이터 (JLPT N5-N1)
- `kanji` - 한자 데이터 (음독/훈독, 획순)
- `user_progress` - 학습 진도 (간격 반복 알고리즘)
- `user_favorites` - 즐겨찾기

### 외부 API
- Web Speech API - 음성 인식 및 TTS
- Canvas API - 손가락 쓰기 기능
- OpenAI/Claude API - 맥락 이해 기능

## Coding Conventions

### 컴포넌트 패턴
```typescript
interface ComponentProps {
  // props 정의
}

export function Component({ prop1, prop2 }: ComponentProps) {
  return (/* JSX */);
}
```

### API Route 패턴
```typescript
import { createRouteHandlerClient } from '@supabase/auth-helpers-nextjs';
import { cookies } from 'next/headers';
import { NextResponse } from 'next/server';

export async function GET(request: Request) {
  const supabase = createRouteHandlerClient({ cookies });
  // ...
}
```

## Environment Variables

```
NEXT_PUBLIC_SUPABASE_URL
NEXT_PUBLIC_SUPABASE_ANON_KEY
SUPABASE_SERVICE_ROLE_KEY
OPENAI_API_KEY (optional)
ANTHROPIC_API_KEY (optional)
```
