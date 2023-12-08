// SPDX-License-Identifier: MIT
pragma solidity >=0.4.24 <0.9.0;

library Cryptofin {

  /**
   * Finds the index of the first occurrence of the given element.
   * @param A The input array to search
   * @param a The value to find
   * @return Returns (index and isIn) for the first occurrence starting from index 0
   */
  function indexOf(uint[] memory A, uint256  a) internal pure returns (uint256, bool) {
    uint256 length = A.length;
    for (uint256 i = 0; i < length; i++) {
      if (A[i] == a) {
        return (i, true);
      }
    }
    return (0, false);
  }

  /**
  * Returns true if the value is present in the list. Uses indexOf internally.
  * @param A The input array to search
  * @param a The value to find
  * @return Returns isIn for the first occurrence starting from index 0
  */
  function contains(uint[] memory A, uint256  a) internal pure returns (bool) {
    (, bool isIn) = indexOf(A, a);
    return isIn;
  }

  /// @return Returns index and isIn for the first occurrence starting from
  /// end
  function indexOfFromEnd(uint[] memory A, uint256  a) internal pure returns (uint256, bool) {
    uint256 length = A.length;
    for (uint256 i = length; i > 0; i--) {
      if (A[i - 1] == a) {
        return (i, true);
      }
    }
    return (0, false);
  }

  /**
   * Returns the combination of the two arrays
   * @param A The first array
   * @param B The second array
   * @return Returns A extended by B
   */
  function extend(uint[] memory A, uint[] memory B) internal pure returns (uint[] memory) {
    uint256 aLength = A.length;
    uint256 bLength = B.length;
    uint[] memory newAddresses = new uint[](aLength + bLength);
    for (uint256 i = 0; i < aLength; i++) {
      newAddresses[i] = A[i];
    }
    for (uint i = 0; i < bLength; i++) {
      newAddresses[aLength + i] = B[i];
    }
    return newAddresses;
  }

  /**
   * Returns the array with a appended to A.
   * @param A The first array
   * @param a The value to append
   * @return Returns A appended by a
   */
  function append(uint[] memory A, uint256  a) internal pure returns (uint[] memory) {
    uint[] memory newAddresses = new uint[](A.length + 1);
    for (uint256 i = 0; i < A.length; i++) {
      newAddresses[i] = A[i];
    }
    newAddresses[A.length] = a;
    return newAddresses;
  }

  /**
   * Returns the combination of two storage arrays.
   * @param A The first array
   * @param B The second array
   */
  function sExtend(uint[] storage A, uint[] storage B) internal {
    uint256 length = B.length;
    for (uint256 i = 0; i < length; i++) {
      A.push(B[i]);
    }
  }

  /**
   * Returns the intersection of two arrays. Arrays are treated as collections, so duplicates are kept.
   * @param A The first array
   * @param B The second array
   * @return The intersection of the two arrays
   */
  function intersect(uint[] memory A, uint[] memory B) internal pure returns (uint[] memory) {
    uint256 length = A.length;
    bool[] memory includeMap = new bool[](length);
    uint256 newLength = 0;
    for (uint256 i = 0; i < length; i++) {
      if (contains(B, A[i])) {
        includeMap[i] = true;
        newLength++;
      }
    }
    uint[] memory newAddresses = new uint[](newLength);
    uint256 j = 0;
    for (uint i = 0; i < length; i++) {
      if (includeMap[i]) {
        newAddresses[j] = A[i];
        j++;
      }
    }
    return newAddresses;
  }

  /**
   * Returns the union of the two arrays. Order is not guaranteed.
   * @param A The first array
   * @param B The second array
   * @return The union of the two arrays
   */
  function union(uint[] memory A, uint[] memory B) internal pure returns (uint[] memory) {
    uint[] memory leftDifference = difference(A, B);
    uint[] memory rightDifference = difference(B, A);
    uint[] memory intersection = intersect(A, B);
    return extend(leftDifference, extend(intersection, rightDifference));
  }

  /**
   * Alternate implementation
   * Assumes there are no duplicates
   */
  function unionB(uint[] memory A, uint[] memory B) internal pure returns (uint[] memory) {
    bool[] memory includeMap = new bool[](A.length + B.length);
    uint256 i = 0;
    uint256 count = 0;
    for (i = 0; i < A.length; i++) {
      includeMap[i] = true;
      count++;
    }
    for (i = 0; i < B.length; i++) {
      if (!contains(A, B[i])) {
        includeMap[A.length + i] = true;
        count++;
      }
    }
    uint[] memory newAddresses = new uint[](count);
    uint256 j = 0;
    for (i = 0; i < A.length; i++) {
      if (includeMap[i]) {
        newAddresses[j] = A[i];
        j++;
      }
    }
    for (i = 0; i < B.length; i++) {
      if (includeMap[A.length + i]) {
        newAddresses[j] = B[i];
        j++;
      }
    }
    return newAddresses;
  }

  /**
   * Computes the difference of two arrays. Assumes there are no duplicates.
   * @param A The first array
   * @param B The second array
   * @return The difference of the two arrays
   */
  function difference(uint[] memory A, uint[] memory B) internal pure returns (uint[] memory) {
    uint256 length = A.length;
    bool[] memory includeMap = new bool[](length);
    uint256 count = 0;
    // First count the new length because can't push for in-memory arrays
    for (uint256 i = 0; i < length; i++) {
      uint256  e = A[i];
      if (!contains(B, e)) {
        includeMap[i] = true;
        count++;
      }
    }
    uint[] memory newAddresses = new uint[](count);
    uint256 j = 0;
    for (uint i = 0; i < length; i++) {
      if (includeMap[i]) {
        newAddresses[j] = A[i];
        j++;
      }
    }
    return newAddresses;
  }

  /**
  * @dev Reverses storage array in place
  */
  function sReverse(uint[] storage A) internal {
    uint256  t;
    uint256 length = A.length;
    for (uint256 i = 0; i < length / 2; i++) {
      t = A[i];
      A[i] = A[A.length - i - 1];
      A[A.length - i - 1] = t;
    }
  }

  /**
  * Removes specified index from array
  * Resulting ordering is not guaranteed
  * @return Returns the new array and the removed entry
  */
  function pop(uint[] memory A, uint256 index)
    internal
    pure
    returns (uint[] memory, uint256  )
  {
    uint256 length = A.length;
    uint[] memory newAddresses = new uint[](length - 1);
    for (uint256 i = 0; i < index; i++) {
      newAddresses[i] = A[i];
    }
    for (uint i = index + 1; i < length; i++) {
      newAddresses[i - 1] = A[i];
    }
    return (newAddresses, A[index]);
  }

  /**
   * @return Returns the new array
   */
  function remove(uint[] memory A, uint256  a)
    internal
    pure
    returns (uint[] memory)
  {
    (uint256 index, bool isIn) = indexOf(A, a);
    if (!isIn) {
      revert();
    } else {
      (uint[] memory _A,) = pop(A, index);
      return _A;
    }
  }

  function sPop(uint[] storage A, uint256 index) internal returns (uint256  ) {
    uint256 length = A.length;
    if (index >= length) {
      revert("Error: index out of bounds");
    }
    uint256  entry = A[index];
    for (uint256 i = index; i < length - 1; i++) {
      A[i] = A[i + 1];
    }
    length--;
    return entry;
  }

  /**
  * Deletes uint256  at index and fills the spot with the last uint256  .
  * Order is not preserved.
  * @return Returns the removed entry
  */
  function sPopCheap(uint[] storage A, uint256 index) internal returns (uint256  ) {
    uint256 length = A.length;
    if (index >= length) {
      revert("Error: index out of bounds");
    }
    uint256  entry = A[index];
    if (index != length - 1) {
      A[index] = A[length - 1];
      delete A[length - 1];
    }
    length--;
    return entry;
  }

  /**
   * Deletes uint256  at index. Works by swapping it with the last uint256  , then deleting.
   * Order is not preserved
   * @param A Storage array to remove from
   */
  function sRemoveCheap(uint[] storage A, uint256  a) internal {
    (uint256 index, bool isIn) = indexOf(A, a);
    if (!isIn) {
      revert("Error: entry not found");
    } else {
      sPopCheap(A, index);
      return;
    }
  }

  /**
   * Returns whether or not there's a duplicate. Runs in O(n^2).
   * @param A Array to search
   * @return Returns true if duplicate, false otherwise
   */
  function hasDuplicate(uint[] memory A) internal pure returns (bool) {
    if (A.length == 0) {
      return false;
    }
    for (uint256 i = 0; i < A.length - 1; i++) {
      for (uint256 j = i + 1; j < A.length; j++) {
        if (A[i] == A[j]) {
          return true;
        }
      }
    }
    return false;
  }

  /**
   * Returns whether the two arrays are equal.
   * @param A The first array
   * @param B The second array
   * @return True is the arrays are equal, false if not.
   */
  function isEqual(uint[] memory A, uint[] memory B) internal pure returns (bool) {
    if (A.length != B.length) {
      return false;
    }
    for (uint256 i = 0; i < A.length; i++) {
      if (A[i] != B[i]) {
        return false;
      }
    }
    return true;
  }

  /**
   * Returns the elements indexed at indexArray.
   * @param A The array to index
   * @param indexArray The array to use to index
   * @return Returns array containing elements indexed at indexArray
   */
  function argGet(uint[] memory A, uint256[] memory indexArray)
    internal
    pure
    returns (uint[] memory)
  {
    uint[] memory array = new uint[](indexArray.length);
    for (uint256 i = 0; i < indexArray.length; i++) {
      array[i] = A[indexArray[i]];
    }
    return array;
  }

}
