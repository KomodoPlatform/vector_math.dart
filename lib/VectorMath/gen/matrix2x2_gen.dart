/*

  VectorMath.dart
  
  Copyright (C) 2012 John McCutchan <john@johnmccutchan.com>
  
  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.

*/
/// mat2x2 is a column major matrix where each column is represented by [vec2]. This matrix has 2 columns and 2 rows.
class mat2x2 {
  vec2 col0;
  vec2 col1;
  /// Constructs a new mat2x2. Supports GLSL like syntax so many possible inputs. Defaults to identity matrix.
  mat2x2([Dynamic arg0, Dynamic arg1, Dynamic arg2, Dynamic arg3]) {
    //Initialize the matrix as the identity matrix
    col0 = new vec2();
    col1 = new vec2();
    col0[0] = 1.0;
    col1[1] = 1.0;
    if (arg0 is num && arg1 is num && arg2 is num && arg3 is num) {
      col0[0] = arg0;
      col0[1] = arg1;
      col1[0] = arg2;
      col1[1] = arg3;
      return;
    }
    if (arg0 is num && arg1 == null && arg2 == null && arg3 == null) {
      col0[0] = arg0;
      col1[1] = arg0;
      return;
    }
    if (arg0 is vec2 && arg1 is vec2) {
      col0 = arg0;
      col1 = arg1;
      return;
    }
    if (arg0 is mat2x2) {
      col0 = arg0.col0;
      col1 = arg0.col1;
      return;
    }
    if (arg0 is vec2 && arg1 == null && arg2 == null && arg3 == null) {
      col0[0] = arg0[0];
      col1[1] = arg0[1];
    }
  }
  /// Constructs a new mat2x2 from computing the outer product of [u] and [v].
  mat2x2.outer(vec2 u, vec2 v) {
    col0[0] = u[0] * v[0];
    col0[1] = u[0] * v[1];
    col1[0] = u[1] * v[0];
    col1[1] = u[1] * v[1];
  }
  /// Constructs a new mat2x2 filled with zeros.
  mat2x2.zero() {
    col0[0] = 0.0;
    col0[1] = 0.0;
    col1[0] = 0.0;
    col1[1] = 0.0;
  }
  /// Returns a printable string
  String toString() {
    String s = '';
    s += '[0] ${getRow(0)}\n';
    s += '[1] ${getRow(1)}\n';
    return s;
  }
  /// Returns the number of rows in the matrix.
  num get rows() => 2;
  /// Returns the number of columns in the matrix.
  num get cols() => 2;
  /// Returns the number of columns in the matrix.
  num get length() => 2;
  /// Gets the [column] of the matrix
  vec2 operator[](int column) {
    assert(column >= 0 && column < 2);
    switch (column) {
      case 0: return col0; break;
      case 1: return col1; break;
    }
    throw new IllegalArgumentException(column);
  }
  /// Assigns the [column] of the matrix [arg]
  vec2 operator[]=(int column, vec2 arg) {
    assert(column >= 0 && column < 2);
    switch (column) {
      case 0: col0 = arg; return col0; break;
      case 1: col1 = arg; return col1; break;
    }
    throw new IllegalArgumentException(column);
  }
  /// Returns row 0
  vec2 get row0() => getRow(0);
  /// Returns row 1
  vec2 get row1() => getRow(1);
  /// Sets row 0 to [arg]
  set row0(vec2 arg) => setRow(0, arg);
  /// Sets row 1 to [arg]
  set row1(vec2 arg) => setRow(1, arg);
  /// Assigns the [column] of the matrix [arg]
  void setRow(int row, vec2 arg) {
    assert(row >= 0 && row < 2);
    this[0][row] = arg[0];
    this[1][row] = arg[1];
  }
  /// Gets the [row] of the matrix
  vec2 getRow(int row) {
    assert(row >= 0 && row < 2);
    vec2 r = new vec2();
    r[0] = this[0][row];
    r[1] = this[1][row];
    return r;
  }
  /// Assigns the [column] of the matrix [arg]
  void setColumn(int column, vec2 arg) {
    assert(column >= 0 && column < 2);
    this[column] = arg;
  }
  /// Gets the [column] of the matrix
  vec2 getColumn(int column) {
    assert(column >= 0 && column < 2);
    return new vec2(this[column]);
  }
  /// Returns a new vector or matrix by multiplying [this] with [arg].
  Dynamic operator*(Dynamic arg) {
    if (arg is num) {
      mat2x2 r = new mat2x2();
      r[0][0] = this[0][0] * arg;
      r[0][1] = this[0][1] * arg;
      r[1][0] = this[1][0] * arg;
      r[1][1] = this[1][1] * arg;
      return r;
    }
    if (arg is vec2) {
      vec2 r = new vec2();
      r[0] = dot(row0, arg);
      r[1] = dot(row1, arg);
      return r;
    }
    if (2 == arg.cols) {
      Dynamic r = null;
      if (arg.rows == 2) {
        r = new mat2x2();
      }
      if (arg.rows == 3) {
        r = new mat2x3();
      }
      if (arg.rows == 4) {
        r = new mat2x4();
      }
      for (int j = 0; j < arg.rows; j++) {
        r[0][j] = dot(this.getRow(0), arg.getColumn(j));
      }
      for (int j = 0; j < arg.rows; j++) {
        r[1][j] = dot(this.getRow(1), arg.getColumn(j));
      }
      return r;
    }
    throw new IllegalArgumentException(arg);
  }
  /// Returns new matrix after component wise [this] + [arg]
  mat2x2 operator+(mat2x2 arg) {
    mat2x2 r = new mat2x2();
    r[0][0] = this[0][0] + arg[0][0];
    r[0][1] = this[0][1] + arg[0][1];
    r[1][0] = this[1][0] + arg[1][0];
    r[1][1] = this[1][1] + arg[1][1];
    return r;
  }
  /// Returns new matrix after component wise [this] - [arg]
  mat2x2 operator-(mat2x2 arg) {
    mat2x2 r = new mat2x2();
    r[0][0] = this[0][0] - arg[0][0];
    r[0][1] = this[0][1] - arg[0][1];
    r[1][0] = this[1][0] - arg[1][0];
    r[1][1] = this[1][1] - arg[1][1];
    return r;
  }
  /// Returns new matrix -this
  mat2x2 operator negate() {
    mat2x2 r = new mat2x2();
    r[0] = -this[0];
    r[1] = -this[1];
    return r;
  }
  /// Returns the tranpose of this.
  mat2x2 transposed() {
    mat2x2 r = new mat2x2();
    r[0][0] = this[0][0];
    r[1][0] = this[0][1];
    r[0][1] = this[1][0];
    r[1][1] = this[1][1];
    return r;
  }
  /// Returns the component wise absolute value of this.
  mat2x2 absolute() {
    mat2x2 r = new mat2x2();
    r[0][0] = this[0][0].abs();
    r[0][1] = this[0][1].abs();
    r[1][0] = this[1][0].abs();
    r[1][1] = this[1][1].abs();
    return r;
  }
  /// Returns the determinant of this matrix.
  num determinant() {
    return (this[0][0] * this[1][1]) - (this[0][1]*this[1][0]); 
  }
  /// Returns the trace of the matrix. The trace of a matrix is the sum of the diagonal entries
  num trace() {
    num t = 0.0;
    t += this[0][0];
    t += this[1][1];
    return t;
  }
  /// Returns infinity norm of the matrix. Used for numerical analysis.
  num infinityNorm() {
    num norm = 0.0;
    {
      num row_norm = 0.0;
      row_norm += this[0][0].abs();
      row_norm += this[0][1].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      num row_norm = 0.0;
      row_norm += this[1][0].abs();
      row_norm += this[1][1].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    return norm;
  }
  /// Returns relative error between [this] and [correct]
  num relativeError(mat2x2 correct) {
    num this_norm = infinityNorm();
    num correct_norm = correct.infinityNorm();
    num diff_norm = (this_norm - correct_norm).abs();
    return diff_norm/correct_norm;
  }
  /// Returns absolute error between [this] and [correct]
  num absoluteError(mat2x2 correct) {
    num this_norm = infinityNorm();
    num correct_norm = correct.infinityNorm();
    num diff_norm = (this_norm - correct_norm).abs();
    return diff_norm;
  }
}
