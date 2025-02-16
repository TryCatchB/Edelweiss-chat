"use client";

import { Dispatch, FC, JSX, SetStateAction, useEffect } from "react";
import { fetchChats } from "@/utils/api";
import { deleteChat as deleteChatApi } from "@/utils/api";
import { Chat } from "@/types/chatInterface";
import { XMarkIcon } from "@heroicons/react/16/solid";

interface ChatListProps {
  chats: Chat[];
  setChats: Dispatch<SetStateAction<Chat[]>>;
  activeChat: number | null;
  setActiveChat: Dispatch<SetStateAction<number | null>>;
}

const ChatList: FC<ChatListProps> = (props): JSX.Element => {
  const { chats, setChats, activeChat, setActiveChat } = props;

  useEffect(() => {
    const getChats = async () => {
      const res = await fetchChats();
      setChats(res);
    };

    getChats();
  }, []);

  const deleteChat = async (id: number) => {
    try {
      await deleteChatApi(id.toString());

      setChats(chats.filter((chat) => chat.id !== id));

      if (activeChat === id) setActiveChat(null);
    } catch (error) {
      console.error("Ошибка при удалении чата:", error);
    }
  };

  return (
    <div className="w-1/4 border-r p-2">
      {chats.map((chat) => (
        <div
          key={chat.id}
          className={`flex justify-between p-2 border cursor-pointer ${
            activeChat === chat.id ? "bg-gray-300" : ""
          }`}
          onClick={() => setActiveChat(chat.id)}
        >
          {chat.title}
          <XMarkIcon
            className="h-5 w-5 text-red-500"
            onClick={(e) => {
              e.stopPropagation();
              deleteChat(chat.id);
            }}
          />
        </div>
      ))}
    </div>
  );
};

export default ChatList;
