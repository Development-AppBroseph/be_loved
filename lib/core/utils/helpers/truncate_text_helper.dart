String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff)
      ? myString
      : '${myString.substring(0, cutoff)}...';
}

String truncateWithEllipsisDualDots(int cutoff, String myString) {
  return (myString.length <= cutoff)
      ? myString
      : '${myString.substring(0, cutoff)}..';
}

String truncateWithEllipsisLast(int cutoff, String myString) {
  return (myString.length <= cutoff)
      ? myString
      : '...${myString.substring(myString.length-cutoff)}';
}