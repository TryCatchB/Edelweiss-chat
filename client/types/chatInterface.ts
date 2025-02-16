export interface Chat {
  id: number;
  title: string;
  messages: { text: string; isError?: boolean }[];
}
