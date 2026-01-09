import 'package:flutter/material.dart';
import '../models/workout_set.dart';

class WorkoutCard extends StatefulWidget {
  final WorkoutSet set;
  final int depth;
  final bool defaultCollapsed;

  const WorkoutCard({
    super.key,
    required this.set,
    this.depth = 0,
    this.defaultCollapsed = true,
  });

  @override
  State<WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  late bool _isCollapsed;

  @override
  void initState() {
    super.initState();
    // Only collapse if this is a container set with nested exercises
    _isCollapsed = widget.set.isContainer && widget.defaultCollapsed;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(left: widget.depth * 16.0),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: widget.set.isContainer
                  ? () {
                      setState(() {
                        _isCollapsed = !_isCollapsed;
                      });
                    }
                  : null,
              child: Row(
                children: [
                  if (widget.set.isContainer)
                    Icon(
                      _isCollapsed
                          ? Icons.chevron_right
                          : Icons.expand_more,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  Expanded(
                    child: Text(
                      widget.set.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  if (widget.set.isLeaf) _buildSetBadge(context),
                  if (widget.set.isContainer && widget.set.sets != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${widget.set.sets!.length} exercise${widget.set.sets!.length == 1 ? '' : 's'}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  if (widget.set.rounds != null && widget.set.rounds! > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      margin: const EdgeInsets.only(left: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${widget.set.rounds}x',
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (widget.set.description != null) ...[
              const SizedBox(height: 4),
              Text(
                widget.set.description!,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ],
            if (widget.set.restBetweenRounds != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.timer_off, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Rest: ${widget.set.restBetweenRounds}s between rounds',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
            if (widget.set.isContainer && widget.set.sets != null && !_isCollapsed) ...[
              const SizedBox(height: 12),
              ...widget.set.sets!.map(
                (childSet) => Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: WorkoutCard(
                    set: childSet,
                    depth: widget.depth + 1,
                    defaultCollapsed: widget.defaultCollapsed,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSetBadge(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isReps = widget.set.type == SetType.reps;
    final color = isReps ? colorScheme.tertiary : colorScheme.secondary;
    final icon = isReps ? Icons.repeat : Icons.timer;
    final text = isReps
        ? '${widget.set.value!.toInt()} reps'
        : '${widget.set.value!.toInt()}s';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
