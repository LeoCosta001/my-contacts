import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_contacts/main.dart';
import 'package:my_contacts/models/contact.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key, required this.contact});

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: darkLightColor,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contact.imageDirectory != null
                        ? FileImage(File(contact.imageDirectory!))
                        : const AssetImage('images/person.png') as ImageProvider,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contact.email,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      contact.phone,
                      style: const TextStyle(fontSize: 16),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
