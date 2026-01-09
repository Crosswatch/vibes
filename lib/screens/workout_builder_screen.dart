import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../models/workout_set.dart';
import '../services/workout_storage_service.dart';

class WorkoutBuilderScreen extends StatefulWidget {
  final Workout? existingWorkout;

  const WorkoutBuilderScreen({super.key, this.existingWorkout});

  @override
  State<WorkoutBuilderScreen> createState() => _WorkoutBuilderScreenState();
}

class _WorkoutBuilderScreenState extends State<WorkoutBuilderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _storageService = WorkoutStorageService();
  final List<WorkoutSet> _sets = [];
  final Set<int> _collapsedSets = {}; // Track which sets are collapsed

  @override
  void initState() {
    super.initState();
    if (widget.existingWorkout != null) {
      _nameController.text = widget.existingWorkout!.name;
      _descriptionController.text = widget.existingWorkout!.description ?? '';
      _sets.addAll(widget.existingWorkout!.sets);
      // Collapse all container sets by default
      for (int i = 0; i < _sets.length; i++) {
        if (_sets[i].isContainer) {
          _collapsedSets.add(i);
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveWorkout() async {
    if (_formKey.currentState!.validate()) {
      if (_sets.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one exercise')),
        );
        return;
      }

      final newName = _nameController.text.trim();
      final oldName = widget.existingWorkout?.name;

      // If editing and name changed, delete the old workout file
      if (oldName != null && oldName != newName) {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Rename Workout?'),
            content: Text(
              'The workout name has changed from "$oldName" to "$newName". '
              'This will create a new workout and delete the old one. Continue?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Continue'),
              ),
            ],
          ),
        );

        if (confirmed != true) {
          return;
        }
      }

      final workout = Workout(
        name: newName,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        sets: _sets,
      );

      try {
        // Delete old workout if name changed
        if (oldName != null && oldName != newName) {
          await _storageService.deleteWorkout(oldName);
        }

        await _storageService.saveWorkout(workout);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.existingWorkout != null
                    ? 'Workout updated successfully!'
                    : 'Workout saved successfully!',
              ),
            ),
          );
          Navigator.pop(context, workout);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to save workout: $e')));
        }
      }
    }
  }

  void _addExercise() {
    showDialog(
      context: context,
      builder: (context) => _ExerciseDialog(
        onSave: (set) {
          setState(() {
            _sets.add(set);
            // Collapse new container sets by default
            if (set.isContainer) {
              _collapsedSets.add(_sets.length - 1);
            }
          });
        },
      ),
    );
  }

  void _editExercise(int index) {
    showDialog(
      context: context,
      builder: (context) => _ExerciseDialog(
        existingSet: _sets[index],
        onSave: (set) {
          setState(() {
            _sets[index] = set;
          });
        },
      ),
    );
  }

  void _deleteExercise(int index) {
    setState(() {
      _sets.removeAt(index);
      // Update collapsed set indices after deletion
      final newCollapsedSets = <int>{};
      for (final collapsedIndex in _collapsedSets) {
        if (collapsedIndex < index) {
          newCollapsedSets.add(collapsedIndex);
        } else if (collapsedIndex > index) {
          newCollapsedSets.add(collapsedIndex - 1);
        }
      }
      _collapsedSets.clear();
      _collapsedSets.addAll(newCollapsedSets);
    });
  }

  void _duplicateExercise(int index) {
    setState(() {
      final duplicatedSet = _sets[index].copy();
      _sets.insert(index + 1, duplicatedSet);
      // Update collapsed set indices after insertion
      final newCollapsedSets = <int>{};
      for (final collapsedIndex in _collapsedSets) {
        if (collapsedIndex <= index) {
          newCollapsedSets.add(collapsedIndex);
        } else {
          newCollapsedSets.add(collapsedIndex + 1);
        }
      }
      // If the original was collapsed, also collapse the duplicate
      if (_collapsedSets.contains(index)) {
        newCollapsedSets.add(index + 1);
      }
      _collapsedSets.clear();
      _collapsedSets.addAll(newCollapsedSets);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingWorkout == null ? 'New Workout' : 'Edit Workout',
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveWorkout,
            tooltip: 'Save Workout',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Workout Name *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a workout name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description (optional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Exercises',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton.icon(
                          onPressed: _addExercise,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Exercise'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_sets.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            'No exercises yet.\nTap "Add Exercise" to get started.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ),
                      )
                    else
                      ReorderableListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _sets.length,
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (newIndex > oldIndex) {
                              newIndex -= 1;
                            }
                            final item = _sets.removeAt(oldIndex);
                            _sets.insert(newIndex, item);
                          });
                        },
                        itemBuilder: (context, index) {
                          final set = _sets[index];
                          return _buildSetCard(set, index);
                        },
                      ),
                  ],
                ),
              ),
            ),
            // Prominent save button at bottom
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveWorkout,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  icon: const Icon(Icons.save),
                  label: const Text(
                    'Save Workout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetCard(WorkoutSet set, int index) {
    final isCollapsed = _collapsedSets.contains(index);
    
    return Card(
      key: ValueKey(index),
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_handle),
                ),
                const SizedBox(width: 8),
                if (set.isContainer)
                  IconButton(
                    icon: Icon(
                      isCollapsed ? Icons.chevron_right : Icons.expand_more,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isCollapsed) {
                          _collapsedSets.remove(index);
                        } else {
                          _collapsedSets.add(index);
                        }
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                Icon(
                  set.isContainer ? Icons.folder : Icons.fitness_center,
                  color: set.isContainer
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            title: Text(
              set.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(_getSetDescription(set)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editExercise(index),
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () => _duplicateExercise(index),
                  tooltip: 'Duplicate',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteExercise(index),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ),
          if (set.isContainer && set.sets != null && !isCollapsed)
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 16, bottom: 8),
              child: Column(
                children: [
                  Text(
                    '${set.sets!.length} exercise${set.sets!.length == 1 ? '' : 's'} in this set',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...set.sets!.asMap().entries.map((entry) {
                    final nestedSet = entry.value;
                    return Card(
                      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                      margin: const EdgeInsets.only(top: 4),
                      child: ListTile(
                        dense: true,
                        leading: Icon(
                          Icons.subdirectory_arrow_right,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: Text(
                          nestedSet.name,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          _getSetDescription(nestedSet),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _getSetDescription(WorkoutSet set) {
    if (set.isContainer) {
      final parts = <String>['${set.sets?.length ?? 0} exercises'];
      
      // Add rounds info
      if (set.rounds != null && set.rounds! > 1) {
        parts.add('${set.rounds} rounds');
      }
      
      // Add rest between rounds
      if (set.restBetweenRounds != null && set.restBetweenRounds! > 0) {
        parts.add('${set.restBetweenRounds!.toInt()}s rest');
      }
      
      // Add transition time if non-default
      if (set.transitionTime != null && set.transitionTime! != 5.0) {
        parts.add('${set.transitionTime!.toInt()}s transition');
      }
      
      return parts.join(' • ');
    }
    
    // For leaf exercises
    final parts = <String>[];
    final type = set.type == SetType.time ? 'Time' : 'Reps';
    final value = set.value?.toInt() ?? 0;
    final unit = set.type == SetType.time ? 's' : ' reps';
    
    // For reps, add estimated time in parentheses
    if (set.type == SetType.reps) {
      final estimatedTime = set.duration?.toInt() ?? (value * 2);
      parts.add('$type: $value$unit (~${estimatedTime}s)');
    } else {
      parts.add('$type: $value$unit');
    }
    
    // Add rounds info
    if (set.rounds != null && set.rounds! > 1) {
      parts.add('${set.rounds}x');
    }
    
    // Add rest between rounds
    if (set.restBetweenRounds != null && set.restBetweenRounds! > 0) {
      parts.add('${set.restBetweenRounds!.toInt()}s rest');
    }
    
    // Add transition time if non-default
    if (set.transitionTime != null && set.transitionTime! != 5.0) {
      parts.add('${set.transitionTime!.toInt()}s transition');
    }
    
    return parts.join(' • ');
  }
}

class _ExerciseDialog extends StatefulWidget {
  final WorkoutSet? existingSet;
  final Function(WorkoutSet) onSave;

  const _ExerciseDialog({this.existingSet, required this.onSave});

  @override
  State<_ExerciseDialog> createState() => _ExerciseDialogState();
}

class _ExerciseDialogState extends State<_ExerciseDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _valueController;
  late final TextEditingController _transitionController;
  late final TextEditingController _roundsController;
  late final TextEditingController _restBetweenRoundsController;
  late final TextEditingController _durationController;
  late SetType _type;
  late bool _isContainer;
  final List<WorkoutSet> _nestedSets = [];

  @override
  void initState() {
    super.initState();
    _isContainer = widget.existingSet?.isContainer ?? false;
    _nameController = TextEditingController(
      text: widget.existingSet?.name ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.existingSet?.description ?? '',
    );
    _valueController = TextEditingController(
      text: widget.existingSet?.value?.toInt().toString() ?? '30',
    );
    _transitionController = TextEditingController(
      text: widget.existingSet?.transitionTime?.toString() ?? '5',
    );
    _roundsController = TextEditingController(
      text: widget.existingSet?.rounds?.toString() ?? '1',
    );
    _restBetweenRoundsController = TextEditingController(
      text: widget.existingSet?.restBetweenRounds?.toString() ?? '',
    );
    _durationController = TextEditingController(
      text: widget.existingSet?.duration?.toString() ?? '',
    );
    _type = widget.existingSet?.type ?? SetType.time;

    if (widget.existingSet?.sets != null) {
      _nestedSets.addAll(widget.existingSet!.sets!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _valueController.dispose();
    _transitionController.dispose();
    _roundsController.dispose();
    _restBetweenRoundsController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _addNestedExercise() {
    showDialog(
      context: context,
      builder: (context) => _ExerciseDialog(
        onSave: (set) {
          setState(() {
            _nestedSets.add(set);
          });
        },
      ),
    );
  }

  void _editNestedExercise(int index) {
    showDialog(
      context: context,
      builder: (context) => _ExerciseDialog(
        existingSet: _nestedSets[index],
        onSave: (set) {
          setState(() {
            _nestedSets[index] = set;
          });
        },
      ),
    );
  }

  void _deleteNestedExercise(int index) {
    setState(() {
      _nestedSets.removeAt(index);
    });
  }

  void _duplicateNestedExercise(int index) {
    setState(() {
      final duplicatedSet = _nestedSets[index].copy();
      _nestedSets.insert(index + 1, duplicatedSet);
    });
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      if (_isContainer && _nestedSets.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add at least one exercise to the set'),
          ),
        );
        return;
      }

      final rounds = int.tryParse(_roundsController.text);
      final restBetweenRounds = double.tryParse(
        _restBetweenRoundsController.text,
      );
      final duration = double.tryParse(_durationController.text);

      final set = WorkoutSet(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        type: _isContainer ? null : _type,
        value: _isContainer ? null : double.tryParse(_valueController.text),
        sets: _isContainer ? _nestedSets : null,
        rounds: (rounds != null && rounds > 1) ? rounds : null,
        restBetweenRounds: restBetweenRounds,
        transitionTime: double.tryParse(_transitionController.text) ?? 5,
        duration: duration,
      );

      widget.onSave(set);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.existingSet == null ? 'Add Exercise' : 'Edit Exercise',
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container/Exercise toggle
                SwitchListTile(
                  title: const Text('Set (Multiple Exercises)'),
                  subtitle: Text(
                    _isContainer
                        ? 'This is a set containing multiple exercises'
                        : 'This is a single exercise',
                  ),
                  value: _isContainer,
                  onChanged: (value) {
                    setState(() {
                      _isContainer = value;
                    });
                  },
                ),
                const Divider(),
                const SizedBox(height: 8),

                // Basic fields
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: _isContainer ? 'Set Name *' : 'Exercise Name *',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),

                // Exercise-specific fields (if not container)
                if (!_isContainer) ...[
                  DropdownButtonFormField<SetType>(
                    initialValue: _type,
                    decoration: const InputDecoration(labelText: 'Type'),
                    items: const [
                      DropdownMenuItem(
                        value: SetType.time,
                        child: Text('Time-based'),
                      ),
                      DropdownMenuItem(
                        value: SetType.reps,
                        child: Text('Rep-based'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _type = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _valueController,
                    decoration: InputDecoration(
                      labelText: _type == SetType.time
                          ? 'Duration (seconds) *'
                          : 'Number of Reps *',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a value';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  if (_type == SetType.reps)
                    TextFormField(
                      controller: _durationController,
                      decoration: const InputDecoration(
                        labelText: 'Estimated Duration (seconds, optional)',
                        hintText: 'Default: 2s per rep',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                ],

                // Nested sets (if container)
                if (_isContainer) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Exercises in Set',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextButton.icon(
                        onPressed: _addNestedExercise,
                        icon: const Icon(Icons.add),
                        label: const Text('Add'),
                      ),
                    ],
                  ),
                  if (_nestedSets.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'No exercises yet. Tap "Add" to add exercises.',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                  else
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _nestedSets.length,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          final item = _nestedSets.removeAt(oldIndex);
                          _nestedSets.insert(newIndex, item);
                        });
                      },
                      itemBuilder: (context, index) {
                        final set = _nestedSets[index];
                        return Card(
                          key: ValueKey(index),
                          child: ListTile(
                            dense: true,
                            leading: ReorderableDragStartListener(
                              index: index,
                              child: const Icon(Icons.drag_handle),
                            ),
                            title: Text(set.name),
                            subtitle: Text(
                              set.type == SetType.time
                                  ? '${set.value?.toInt()}s'
                                  : '${set.value?.toInt()} reps',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 20),
                                  onPressed: () => _editNestedExercise(index),
                                  tooltip: 'Edit',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy, size: 20),
                                  onPressed: () => _duplicateNestedExercise(index),
                                  tooltip: 'Duplicate',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, size: 20),
                                  onPressed: () => _deleteNestedExercise(index),
                                  tooltip: 'Delete',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],

                const SizedBox(height: 12),
                const Divider(),
                Text(
                  'Advanced Options',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),

                // Rounds and rest
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _roundsController,
                        decoration: const InputDecoration(
                          labelText: 'Rounds',
                          hintText: '1',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _restBetweenRoundsController,
                        decoration: const InputDecoration(
                          labelText: 'Rest (seconds)',
                          hintText: 'Optional',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _transitionController,
                  decoration: const InputDecoration(
                    labelText: 'Transition Time (seconds)',
                    hintText: '5',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
