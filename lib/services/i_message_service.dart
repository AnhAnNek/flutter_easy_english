abstract class IMessageService {
  Future getAllMessages(senderUsername, recipientUsername, page, size);
  Future getRecentChats(page, size);
}