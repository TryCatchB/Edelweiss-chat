import React, { FC, JSX } from "react";
import { ChatItemProps } from "@/types/chatInterface";
import { XMarkIcon } from "@heroicons/react/16/solid";

const ChatItem: FC<ChatItemProps> = ({ chat, deleteChat }): JSX.Element => {
  return (
    <>
      {chat.title}
      <XMarkIcon
        className="h-5 w-5 text-red-500"
        onClick={(e) => {
          e.stopPropagation();
          deleteChat(chat.id);
        }}
      />
    </>
  );
};

export default ChatItem;
