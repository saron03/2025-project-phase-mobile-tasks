import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatApiService {
  final http.Client client;
  final String baseUrl = 'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3';

  ChatApiService({required this.client});

  Future<List<dynamic>> getChats(String userId, String authToken) async {
    final response = await client.get(
      Uri.parse('$baseUrl/chats?userId=$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to fetch chats: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getChatById(String chatId, String authToken) async {
    final response = await client.get(
      Uri.parse('$baseUrl/chats/$chatId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch chat: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> getMessages(String chatId, String authToken) async {
    final response = await client.get(
      Uri.parse('$baseUrl/chats/$chatId/messages'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to fetch messages: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> initiateChat(String userId, String authToken) async {
    final response = await client.post(
      Uri.parse('$baseUrl/chats'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode({'userId': userId}),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to initiate chat: ${response.statusCode}');
    }
  }

  Future<void> deleteChat(String chatId, String authToken) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/chats/$chatId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete chat: ${response.statusCode}');
    }
  }
}