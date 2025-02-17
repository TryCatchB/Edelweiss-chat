import { Chat } from "@/types/chatInterface";
import axios from "axios";

export const API_URL = "http://127.0.0.1:8080/chats";

// Получить список чатов
export const fetchChats = async (): Promise<Chat[]> => {
  try {
    const { data } = await axios.get(API_URL);
    return data;
  } catch (error) {
    throw new Error("Ошибка при загрузке чатов");
  }
};

// Создать новый чат
export const createChat = async (title: string) => {
  try {
    const createdAt = new Date()
      .toLocaleString("sv-SE", { timeZoneName: "short" })
      .replace(" ", "T"); // Пример: "2025-02-17T15:30:00+03"

    const { data } = await axios.post(API_URL, { title, createdAt }); // Добавили createdAt
    return data;
  } catch (error) {
    throw new Error("Ошибка при создании чата");
  }
};

// Удалить чат
export const deleteChat = async (id: string) => {
  try {
    await axios.delete(`${API_URL}/${id}`);
  } catch (error) {
    throw new Error("Ошибка при удалении чата");
  }
};

// Отправить сообщение в чат
export const sendMessage = async (chatId: string, content: string) => {
  try {
    const { data } = await axios.post(`${API_URL}/${chatId}/messages`, {
      chatId,
      content,
    });
    return data;
  } catch (error) {
    throw new Error("Ошибка при отправке сообщения");
  }
};

// Получить все сообщения из чата
export const getMessages = async (chatId: string) => {
  try {
    const { data } = await axios.get(`${API_URL}/${chatId}/messages`);
    return data;
  } catch (error) {
    throw new Error("Ошибка при загрузке сообщений");
  }
};
