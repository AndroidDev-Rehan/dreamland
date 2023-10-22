enum FloorCondition{
  good,
  workNeeded
}

FloorCondition? getFloorCondition(String? floorCondition){
  try {
    return FloorCondition.values.firstWhere(
          (element) => element.name == floorCondition,
    );
  }
  catch (e){
    return null;
  }
}