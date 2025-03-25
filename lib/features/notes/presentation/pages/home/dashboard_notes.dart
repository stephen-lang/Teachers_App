import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteItem extends StatefulWidget {
  final note;
  final Color color;
  final Function onEdit;
  final Function onDelete;
  final Function onShowPopup;

  const NoteItem({
    super.key,
    required this.note,
    required this.color,
    required this.onEdit,
    required this.onDelete,
    required this.onShowPopup,
  });

  @override
  // ignore: library_private_types_in_public_api
  _NoteItemState createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onShowPopup(context, widget.note,),
      onHover: (hovering) => setState(() => isHovered = hovering), // ✅ InkWell hover detection
      borderRadius: BorderRadius.circular(15), // ✅ Ensures ripple effect follows shape
      splashColor: Colors.blue.withOpacity(0.2), // ✅ Light ripple effect on tap
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(isHovered ? 1.05 : 1.0), // ✅ Smooth scaling on hover
        child: Card(
          elevation: isHovered ? 8 : 2, // ✅ Increase elevation when hovered
          margin: const EdgeInsets.symmetric(vertical: 8),
          color: widget.color.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Colors.blue.shade700, width: 1),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            title: Text(
              widget.note.Subject,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.note.indicators),
                Text(
                  "Updated: ${DateFormat("d MMM, yyyy").format(widget.note.updatedAt)}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == "Edit") {
                  widget.onEdit(widget.note);
                } else if (value == "Delete") {
                  widget.onDelete(widget.note);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: "Edit", child: Text("Edit")),
                const PopupMenuItem(value: "Delete", child: Text("Delete")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
