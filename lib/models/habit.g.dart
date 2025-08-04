// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 2;

  @override
  Habit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Habit(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      color: Color(fields[3] as int),
      category: fields[4] as Category,
      goalType: fields[5] as GoalType,
      targetCount: fields[6] as int,
      completions: (fields[9] as Map?)?.cast<DateTime, int>(),
      createdAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.colorValue)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.goalType)
      ..writeByte(6)
      ..write(obj.targetCount)
      ..writeByte(7)
      ..write(obj.reminderHour)
      ..writeByte(8)
      ..write(obj.reminderMinute)
      ..writeByte(9)
      ..write(obj.completions)
      ..writeByte(10)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GoalTypeAdapter extends TypeAdapter<GoalType> {
  @override
  final int typeId = 0;

  @override
  GoalType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GoalType.daily;
      case 1:
        return GoalType.weekly;
      case 2:
        return GoalType.monthly;
      default:
        return GoalType.daily;
    }
  }

  @override
  void write(BinaryWriter writer, GoalType obj) {
    switch (obj) {
      case GoalType.daily:
        writer.writeByte(0);
        break;
      case GoalType.weekly:
        writer.writeByte(1);
        break;
      case GoalType.monthly:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 1;

  @override
  Category read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Category.health;
      case 1:
        return Category.productivity;
      case 2:
        return Category.learning;
      case 3:
        return Category.fitness;
      case 4:
        return Category.mindfulness;
      case 5:
        return Category.social;
      case 6:
        return Category.finance;
      case 7:
        return Category.other;
      default:
        return Category.health;
    }
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    switch (obj) {
      case Category.health:
        writer.writeByte(0);
        break;
      case Category.productivity:
        writer.writeByte(1);
        break;
      case Category.learning:
        writer.writeByte(2);
        break;
      case Category.fitness:
        writer.writeByte(3);
        break;
      case Category.mindfulness:
        writer.writeByte(4);
        break;
      case Category.social:
        writer.writeByte(5);
        break;
      case Category.finance:
        writer.writeByte(6);
        break;
      case Category.other:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
