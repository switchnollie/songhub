type ChangeVal = FirebaseFirestore.DocumentData | undefined;

export function shallowDiff(oldVal: ChangeVal, newVal: ChangeVal) {
  let diffObj: {[key: string]: any} = {};
  if (newVal && oldVal) {
    for (let [key, val] of Object.entries(newVal)) {
      if (oldVal[key] !== val) {
        diffObj[key] = val;
      }
    }
  }
  return diffObj;
}