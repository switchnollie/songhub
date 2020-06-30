type ChangeVal = FirebaseFirestore.DocumentData | undefined;

export function shallowDiff(oldVal: ChangeVal, newVal: ChangeVal) {
  const diffObj: { [key: string]: any } = {};
  if (newVal && oldVal) {
    for (const [key, val] of Object.entries(newVal)) {
      if (oldVal[key] !== val) {
        diffObj[key] = val;
      }
    }
  }
  return diffObj;
}
