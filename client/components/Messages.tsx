import { Chat } from "@/types/chatInterface";
import { getMessages, sendMessage } from "@/utils/api";
import React, {
  Dispatch,
  FC,
  JSX,
  SetStateAction,
  useEffect,
  useState,
} from "react";

interface MessagesProps {
  chats: Chat[];
  activeChat: number | null;
  setChats: Dispatch<SetStateAction<Chat[]>>;
}

const Messages: FC<MessagesProps> = (props): JSX.Element => {
  const { chats, activeChat, setChats } = props;

  const [message, setMessage] = useState("");

  useEffect(() => {
    const loadMessages = async () => {
      if (activeChat) {
        const messagesData = await getMessages(String(activeChat));
        setChats((prevChats) =>
          prevChats.map((chat) =>
            chat.id === activeChat ? { ...chat, messages: messagesData } : chat
          )
        );
      }
    };

    loadMessages();
  }, [activeChat]);

  const handleSendMessage = async () => {
    if (!message.trim() || activeChat === null) return;

    try {
      const newMessage = await sendMessage(String(activeChat), message);

      setChats((prevChats) =>
        prevChats.map((chat) =>
          chat.id === activeChat
            ? { ...chat, messages: [...chat.messages, newMessage] }
            : chat
        )
      );
      setMessage("");
    } catch (error) {
      console.error("Ошибка при отправке сообщения", error);
    }
  };

  return (
    <div className="flex-1 flex flex-col p-4">
      {activeChat !== null ? (
        <div className="flex flex-col h-full border p-2">
          <div className="flex-1 overflow-auto">
            {chats
              .find((chat) => chat.id === activeChat)
              ?.messages.map((msg, index) => (
                <div
                  key={index}
                  className={`p-2 ${msg.isError ? "text-red-500" : ""}`}
                >
                  {msg.text}
                </div>
              ))}
          </div>
          <div className="flex p-2 border-t">
            <input
              className="flex-1 border p-2"
              value={message}
              onChange={(e) => setMessage(e.target.value)}
              placeholder="Введите сообщение"
            />
            <button
              onClick={handleSendMessage}
              className="bg-green-500 text-white p-2 ml-2"
            >
              Send
            </button>
          </div>
        </div>
      ) : (
        <div className="text-gray-500">Выберите чат</div>
      )}
    </div>
  );
};

export default Messages;
