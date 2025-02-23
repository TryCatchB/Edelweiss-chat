import { FC, JSX, useState } from "react";
import { MessageInputProps } from "@/types/chatInterface";
import { sendMessage } from "@/utils/api";

const MessageInput: FC<MessageInputProps> = (props): JSX.Element => {
  const { setChats, activeChat } = props;
  const [message, setMessage] = useState("");

  const handleSendMessage = async () => {
    if (!message.trim() || !activeChat) return;

    try {
      const newMessage = await sendMessage(String(activeChat), message);

      setChats((prevChats) =>
        prevChats.map((chat) =>
          chat.id === activeChat
            ? {
                ...chat,
                messages: [
                  ...(chat.messages ?? []),
                  { role: "user", content: message },
                  newMessage,
                ],
              }
            : chat
        )
      );

      setMessage("");
    } catch (error) {
      console.error("Ошибка при отправке сообщения", error);
    }
  };

  return (
    <div className="flex">
      <input
        className="flex-1 border p-2 text-black"
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
  );
};

export default MessageInput;
