enum Material{
  cc,
  cl,
  cv,
  lv,
  ep,
  dp,
}

Material? getMaterial(String material){
  try {
    return Material.values.firstWhere(
      (element) => element.name == material,
    );
  }
  catch (e){
    return null;
  }
}