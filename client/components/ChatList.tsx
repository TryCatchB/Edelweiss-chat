import { FC, JSX, useEffect } from "react";
import { fetchChats } from "@/utils/api";
import { deleteChat as deleteChatApi } from "@/utils/api";
import { ChatListProps } from "@/types/chatInterface";
import ChatItem from "@/UI/ChatItem";

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
    <div className="p-2 flex flex-col gap-4">
      {chats.map((chat) => (
        <div
          key={chat.id}
          className={`flex justify-between p-2 border cursor-pointer ${
            activeChat === chat.id ? "bg-gray-600" : ""
          }`}
          onClick={() => setActiveChat(chat.id)}
        >
          <ChatItem chat={chat} deleteChat={deleteChat} />
        </div>
      ))}
    </div>
  );
};

export default ChatList;
