import React, { FC, useEffect, useMemo, JSX } from "react";
import { MessagesProps } from "@/types/chatInterface";
import { getMessages } from "@/utils/api";
import MessageInput from "@/UI/MessageInput";

const Messages: FC<MessagesProps> = (props): JSX.Element => {
  const { chats, activeChat, setChats } = props;

  const activeChatData = useMemo(
    () => chats.find((chat) => chat.id === activeChat),
    [chats, activeChat]
  );

  useEffect(() => {
    if (!activeChat) return;

    (async () => {
      const messagesData = await getMessages(String(activeChat));
      setChats((prevChats) =>
        prevChats.map((chat) =>
          chat.id === activeChat ? { ...chat, messages: messagesData } : chat
        )
      );
    })();
  }, [activeChat, setChats]);

  return (
    <div className="flex-1 flex flex-col p-4">
      {activeChatData ? (
        <div className="flex flex-col h-full border p-2">
          <div className="flex-1 overflow-auto">
            {activeChatData.messages?.map((msg, index) => (
              <div
                key={index}
                className={`p-2 ${msg.isError ? "text-red-500" : "text-white"}`}
              >
                {msg.content}
              </div>
            ))}
          </div>
          <div className="flex p-2 border-t">
            <MessageInput setChats={setChats} activeChat={activeChat} />
          </div>
        </div>
      ) : (
        <div className="text-gray-500">Выберите чат</div>
      )}
    </div>
  );
};

export default Messages;
