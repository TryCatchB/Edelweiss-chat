"use client";

import { FC, JSX, useState } from "react";
import ChatList from "@/components/ChatList";
import CreateChat from "@/components/CreateChat";
import Messages from "@/components/Messages";
import { Chat } from "@/types/chatInterface";

const ChatApp: FC = (): JSX.Element => {
  const [chats, setChats] = useState<Chat[]>([]);
  const [activeChat, setActiveChat] = useState<number | null>(null);

  return (
    <div className="flex w-full h-screen border p-4">
      <div className="w-1/4 border-r p-2">
        <CreateChat
          chats={chats}
          setChats={setChats}
          setActiveChat={setActiveChat}
        />
        <ChatList
          chats={chats}
          setChats={setChats}
          activeChat={activeChat}
          setActiveChat={setActiveChat}
        />
      </div>
      <Messages chats={chats} activeChat={activeChat} setChats={setChats} />
    </div>
  );
};

export default ChatApp;
