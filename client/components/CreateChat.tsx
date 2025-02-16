import { Chat } from "@/types/chatInterface";
import { createChat as createChatAPI } from "@/utils/api";
import { PlusIcon } from "@heroicons/react/16/solid";
import React, { Dispatch, FC, JSX, SetStateAction } from "react";

interface CreateChatProps {
  chats: Chat[];
  setChats: Dispatch<SetStateAction<Chat[]>>;
  setActiveChat: Dispatch<SetStateAction<number | null>>;
}

const CreateChat: FC<CreateChatProps> = (props): JSX.Element => {
  const { chats, setChats, setActiveChat } = props;

  const createChat = async () => {
    try {
      const chatNumber = chats.length + 1;
      const newChatTitle = `Чат ${chatNumber}`;

      const createdChat = await createChatAPI(newChatTitle);

      const newChat: Chat = {
        id: createdChat.id,
        title: createdChat.title,
        messages: [],
      };

      setChats([...chats, newChat]);
      setActiveChat(newChat.id);
    } catch (error) {
      console.error("Ошибка при создании чата:", error);
    }
  };

  return (
    <>
      <button
        onClick={createChat}
        className="flex items-center bg-blue-500 text-white p-2 w-full mb-2"
      >
        <PlusIcon className="h-5 w-5 mr-2" /> Создать чат
      </button>
    </>
  );
};

export default CreateChat;
