import { Dispatch, SetStateAction } from "react";

export interface Chat {
  id: number;
  title: string;
  messages: { content: string; isError?: boolean }[];
}

export interface BaseSetChats {
  setChats: Dispatch<SetStateAction<Chat[]>>;
}

export interface BaseChatProps extends BaseSetChats {
  chats: Chat[];
}

export interface WithActiveChat {
  activeChat: number | null;
}

export interface WithSetActiveChat {
  setActiveChat: Dispatch<SetStateAction<number | null>>;
}

export interface ChatItemProps {
  chat: Chat;
  deleteChat: (id: number) => Promise<void>;
}

export interface MessagesProps extends BaseChatProps, WithActiveChat {}

export interface CreateChatProps extends BaseChatProps, WithSetActiveChat {}

export interface ChatListProps
  extends BaseChatProps,
    WithActiveChat,
    WithSetActiveChat {}

export interface MessageInputProps extends BaseSetChats, WithActiveChat {}
