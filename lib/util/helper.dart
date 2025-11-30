String short(String s, [int len=40]) {
  if (s.length <= len) return s;
  return '${s.substring(0,len)}...';
}
