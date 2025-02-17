import { FC, JSX } from "react";
import { Chat, CreateChatProps } from "@/types/chatInterface";
import { createChat as createChatAPI } from "@/utils/api";
import { PlusIcon } from "@heroicons/react/16/solid";

const CreateChat: FC<CreateChatProps> = (props): JSX.Element => {
  const { chats, setChats, setActiveChat } = props;

  const createChat = async () => {
    try {
      const chatNumber = chats.length + 1;
      const newChatTitle = `Чат ${chatNumber}`;

      const createdChat = await createChatAPI(newChatTitle);

      setChats((prevChats) => {
        const newChat: Chat = {
          id: createdChat.id,
          title: createdChat.title,
          messages: [],
        };
        return [...prevChats, newChat];
      });

      setActiveChat(createdChat.id);
    } catch (error) {
      console.error("Ошибка при создании чата:", error);
    }
  };

  return (
    <button
      onClick={createChat}
      className="flex items-center bg-blue-500 text-white p-2 w-full mb-2"
    >
      <PlusIcon className="h-5 w-5 mr-2" /> Создать чат
    </button>
  );
};

export default CreateChat;
