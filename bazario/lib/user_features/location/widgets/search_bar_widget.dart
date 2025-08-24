import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.black.withOpacity(0.2),
          width: 0.2,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            LucideIcons.search,
            color: Colors.grey,
            size: 30,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Golden Avenue',
                hintStyle: TextStyle(
                    color: Color(0xff8b8b8b), fontSize: 16),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              LucideIcons.circleX,
              color: Color(0xff704f38),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
