/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0.  If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * This Source Code Form is "Incompatible With Secondary Licenses",
 * as defined by the Mozilla Public License, v. 2.0.
 */

package util
{
	
	/**
	 * http://webstaff.itn.liu.se/~stegu/simplexnoise/simplexnoise.pdf
	 */
	public class SimplexNoise
	{
		
		private var grad3:Vector.<Vector.<int>> = new <Vector.<int>>[
			new <int>[1, 1, 0],
			new <int>[-1, 1, 0],
			new <int>[1, -1, 0],
			new <int>[-1, -1, 0],
			new <int>[1, 0, 1],
			new <int>[-1, 0, 1],
			new <int>[1, 0, -1],
			new <int>[-1, 0, -1],
			new <int>[0, 1, 1],
			new <int>[0, -1, 1],
			new <int>[0, 1, -1],
			new <int>[0, -1, -1]
		];
		
		private var p:Vector.<int> = new <int>(258);
		
		private var perm:Vector.<int>;
		private var permMod12:Vector.<int>;
		
		private var sqrt3:Number = Math.sqrt(3);
		
		public function SimplexNoise()
		{
			var i = 0;
			p[i++] = 151;
			p[i++] = 160;
			p[i++] = 137;
			p[i++] = 91;
			p[i++] = 90;
			p[i++] = 15;
			p[i++] = 131;
			p[i++] = 13;
			p[i++] = 201;
			p[i++] = 95;
			p[i++] = 96;
			p[i++] = 53;
			p[i++] = 194;
			p[i++] = 233;
			p[i++] = 7;
			p[i++] = 225;
			p[i++] = 140;
			p[i++] = 36;
			p[i++] = 103;
			p[i++] = 30;
			p[i++] = 69;
			p[i++] = 142;
			p[i++] = 8;
			p[i++] = 99;
			p[i++] = 37;
			p[i++] = 240;
			p[i++] = 21;
			p[i++] = 10;
			p[i++] = 23;
			p[i++] = 190;
			p[i++] = 6;
			p[i++] = 148;
			p[i++] = 247;
			p[i++] = 120;
			p[i++] = 234;
			p[i++] = 75;
			p[i++] = 0;
			p[i++] = 26;
			p[i++] = 197;
			p[i++] = 62;
			p[i++] = 94;
			p[i++] = 252;
			p[i++] = 219;
			p[i++] = 203;
			p[i++] = 117;
			p[i++] = 35;
			p[i++] = 11;
			p[i++] = 32;
			p[i++] = 57;
			p[i++] = 177;
			p[i++] = 33;
			p[i++] = 88;
			p[i++] = 237;
			p[i++] = 149;
			p[i++] = 56;
			p[i++] = 87;
			p[i++] = 174;
			p[i++] = 20;
			p[i++] = 125;
			p[i++] = 136;
			p[i++] = 171;
			p[i++] = 168;
			p[i++] = 68;
			p[i++] = 175;
			p[i++] = 74;
			p[i++] = 165;
			p[i++] = 71;
			p[i++] = 134;
			p[i++] = 139;
			p[i++] = 48;
			p[i++] = 27;
			p[i++] = 166;
			p[i++] = 77;
			p[i++] = 146;
			p[i++] = 158;
			p[i++] = 231;
			p[i++] = 83;
			p[i++] = 111;
			p[i++] = 229;
			p[i++] = 122;
			p[i++] = 60;
			p[i++] = 211;
			p[i++] = 133;
			p[i++] = 230;
			p[i++] = 220;
			p[i++] = 105;
			p[i++] = 92;
			p[i++] = 41;
			p[i++] = 55;
			p[i++] = 46;
			p[i++] = 245;
			p[i++] = 40;
			p[i++] = 244;
			p[i++] = 102;
			p[i++] = 143;
			p[i++] = 54;
			p[i++] = 65;
			p[i++] = 25;
			p[i++] = 63;
			p[i++] = 161;
			p[i++] = 1;
			p[i++] = 216;
			p[i++] = 80;
			p[i++] = 73;
			p[i++] = 209;
			p[i++] = 76;
			p[i++] = 132;
			p[i++] = 187;
			p[i++] = 208;
			p[i++] = 89;
			p[i++] = 18;
			p[i++] = 169;
			p[i++] = 200;
			p[i++] = 196;
			p[i++] = 135;
			p[i++] = 130;
			p[i++] = 116;
			p[i++] = 188;
			p[i++] = 159;
			p[i++] = 86;
			p[i++] = 164;
			p[i++] = 100;
			p[i++] = 109;
			p[i++] = 198;
			p[i++] = 173;
			p[i++] = 186;
			p[i++] = 3;
			p[i++] = 64;
			p[i++] = 52;
			p[i++] = 217;
			p[i++] = 226;
			p[i++] = 250;
			p[i++] = 124;
			p[i++] = 123;
			p[i++] = 5;
			p[i++] = 202;
			p[i++] = 38;
			p[i++] = 147;
			p[i++] = 118;
			p[i++] = 126;
			p[i++] = 255;
			p[i++] = 82;
			p[i++] = 85;
			p[i++] = 212;
			p[i++] = 207;
			p[i++] = 206;
			p[i++] = 59;
			p[i++] = 227;
			p[i++] = 47;
			p[i++] = 16;
			p[i++] = 58;
			p[i++] = 17;
			p[i++] = 182;
			p[i++] = 189;
			p[i++] = 28;
			p[i++] = 42;
			p[i++] = 223;
			p[i++] = 183;
			p[i++] = 170;
			p[i++] = 213;
			p[i++] = 119;
			p[i++] = 248;
			p[i++] = 152;
			p[i++] = 2;
			p[i++] = 44;
			p[i++] = 154;
			p[i++] = 163;
			p[i++] = 70;
			p[i++] = 221;
			p[i++] = 153;
			p[i++] = 101;
			p[i++] = 155;
			p[i++] = 167;
			p[i++] = 43;
			p[i++] = 172;
			p[i++] = 9;
			p[i++] = 129;
			p[i++] = 22;
			p[i++] = 39;
			p[i++] = 253;
			p[i++] = 19;
			p[i++] = 98;
			p[i++] = 108;
			p[i++] = 110;
			p[i++] = 79;
			p[i++] = 113;
			p[i++] = 224;
			p[i++] = 232;
			p[i++] = 178;
			p[i++] = 185;
			p[i++] = 112;
			p[i++] = 104;
			p[i++] = 218;
			p[i++] = 246;
			p[i++] = 97;
			p[i++] = 228;
			p[i++] = 251;
			p[i++] = 34;
			p[i++] = 242;
			p[i++] = 193;
			p[i++] = 238;
			p[i++] = 210;
			p[i++] = 144;
			p[i++] = 12;
			p[i++] = 191;
			p[i++] = 179;
			p[i++] = 162;
			p[i++] = 241;
			p[i++] = 81;
			p[i++] = 51;
			p[i++] = 145;
			p[i++] = 235;
			p[i++] = 249;
			p[i++] = 14;
			p[i++] = 239;
			p[i++] = 107;
			p[i++] = 49;
			p[i++] = 192;
			p[i++] = 214;
			p[i++] = 31;
			p[i++] = 181;
			p[i++] = 199;
			p[i++] = 106;
			p[i++] = 157;
			p[i++] = 184;
			p[i++] = 84;
			p[i++] = 204;
			p[i++] = 176;
			p[i++] = 115;
			p[i++] = 121;
			p[i++] = 50;
			p[i++] = 45;
			p[i++] = 127;
			p[i++] = 4;
			p[i++] = 150;
			p[i++] = 254;
			p[i++] = 138;
			p[i++] = 236;
			p[i++] = 205;
			p[i++] = 93;
			p[i++] = 222;
			p[i++] = 114;
			p[i++] = 67;
			p[i++] = 29;
			p[i++] = 24;
			p[i++] = 72;
			p[i++] = 243;
			p[i++] = 141;
			p[i++] = 128;
			p[i++] = 195;
			p[i++] = 78;
			p[i++] = 66;
			p[i++] = 215;
			p[i++] = 61;
			p[i++] = 156;
			p[i++] = 180;
			
			perm = new Vector.<int>(512);
			permMod12 = new Vector.<int>(512);
			for (i = 0; i < 512; i++)
			{
				var pv:int = p[i & 255];
				perm[i] = pv;
				permMod12[i] = pv % 12;
			}
			p.length = 0;
			p = null;
		}
		
		private function floor(n:Number):int 
		{
			return n > 0 ? int(n) : int(n)-1;
		}
		
		private function dot(g:Vector.<int>, x:Number, y:Number):Number
		{
			return g[0]*x+g[1]*y;
		}
		private function dot3(g:Vector.<int>, x:Number, y:Number, z:Number):Number
		{
			return g[0]*x+g[1]*y+g[2]*z;
		}
		
		//public function harmonicNoise2D(x:Number, y:Number, harmonics:int = 3, frequency:Number = 1, smoothness:Number = 1):Number {
		public function harmonicNoise2D(x:Number, y:Number, harmonics:int = 3, freqX:Number = 1, freqY:Number = 1, smoothness:Number = 1):Number
		{
			var h:Number = 1;
			var sum:Number = 0;
			for (var i:int = 0; i < harmonics; i++)
			{
				sum += noise2D(x*h*freqX, y*h*freqY)/smoothness;
				h *= 2;
			}
			sum /= harmonics;
			return sum;
		}
		
		public function harmonicNoise3D(x:Number, y:Number, z:Number, harmonics:int = 3, freqX:Number = 1, freqY:Number = 1, freqZ:Number = 1, smoothness:Number = 1):Number
		{
			var h:Number = 1;
			var sum:Number = 0;
			for (var i:int = 0; i < harmonics; i++)
			{
				sum += noise3D(x*h*freqX, y*h*freqY, z*h*freqZ)/smoothness;
				h *= 2;
			}
			sum /= harmonics;
			return sum;
		}
		
		public function noise2D(x:Number, y:Number):Number
		{
			var n0:Number, n1:Number, n2:Number;
			var F2:Number = 0.5*(sqrt3-1);
			var s:Number = (x+y)*F2;
			var i:int = floor(x+s);
			var j:int = floor(y+s);
			var G2:Number = (3-sqrt3)/6;
			var t:Number = (i+j)*G2;
			var X0:Number = i-t;
			var Y0:Number = j-t;
			var x0:Number = x-X0;
			var y0:Number = y-Y0;
			var i1:int, j1:int;
			if (x0 > y0)
			{
				i1 = 1; j1 = 0;
			}
			else
			{
				i1 = 0; j1 = 1;
			}
			var x1:Number = x0-i1+G2;
			var y1:Number = y0-j1+G2;
			var x2:Number = x0-1+2*G2;
			var y2:Number = y0-1+2*G2;
			var ii:int = i & 255;
			var jj:int = j & 255;
			var gi0:int = perm[ii+perm[jj]] % 12;
			var gi1:int = perm[ii+i1+perm[jj+j1]] % 12;
			var gi2:int = perm[ii+1+perm[jj+1]] % 12;
			
			var t0:Number = 0.5-x0*x0-y0*y0;
			if (t0 < 0)
			{
				n0 = 0;
			} else
			{
				t0 *= t0;
				n0 = t0*t0*dot(grad3[gi0], x0, y0);
			}
			
			var t1:Number = 0.5-x1*x1-y1*y1;
			if (t1 < 0)
			{
				n1 = 0;
			}
			else
			{
				t1 *= t1;
				n1 = t1*t1*dot(grad3[gi1], x1, y1);
			}
			
			var t2:Number = 0.5-x2*x2-y2*y2;
			if (t2 < 0)
			{
				n2 = 0;
			}
			else
			{
				t2 *= t2;
				n2 = t2*t2*dot(grad3[gi2], x2, y2);
			}
			
			return 70*(n0+n1+n2);
		}
		public function noise3D(x:Number, y:Number, z:Number):Number
		{
			var n0:Number, n1:Number, n2:Number, n3:Number; // Noise contributions from the four corners
			
			var F3:Number = 1.0 / 3.0;
			var G3:Number = 1.0 / 6.0;
			
			// Skew the input space to determine which simplex cell we're in
			var s:Number = (x+y+z)*F3; // Very nice and simple skew factor for 3D
			var i:int = floor(x+s);
			var j:int = floor(y+s);
			var k:int = floor(z+s);
			var t:Number = (i+j+k)*G3;
			var X0:Number = i-t; // Unskew the cell origin back to (x,y,z) space
			var Y0:Number = j-t;
			var Z0:Number = k-t;
			var x0:Number = x-X0; // The x,y,z distances from the cell origin
			var y0:Number = y-Y0;
			var z0:Number = z-Z0;
			// For the 3D case, the simplex shape is a slightly irregular tetrahedron.
			// Determine which simplex we are in.
			var i1:int, j1:int, k1:int; // Offsets for second corner of simplex in (i,j,k) coords
			var i2:int, j2:int, k2:int; // Offsets for third corner of simplex in (i,j,k) coords
			if (x0 >= y0)
			{
				     if (y0 >= z0) { i1=1; j1=0; k1=0; i2=1; j2=1; k2=0; } // X Y Z order
				else if (x0 >= z0) { i1=1; j1=0; k1=0; i2=1; j2=0; k2=1; } // X Z Y order
				              else { i1=0; j1=0; k1=1; i2=1; j2=0; k2=1; } // Z X Y order
			}
			else
			{ // x0<y0
				    if (y0 < z0) { i1=0; j1=0; k1=1; i2=0; j2=1; k2=1; } // Z Y X order
				else if(x0 < z0) { i1=0; j1=1; k1=0; i2=0; j2=1; k2=1; } // Y Z X order
				            else { i1=0; j1=1; k1=0; i2=1; j2=1; k2=0; } // Y X Z order
			}
			// A step of (1,0,0) in (i,j,k) means a step of (1-c,-c,-c) in (x,y,z),
			// a step of (0,1,0) in (i,j,k) means a step of (-c,1-c,-c) in (x,y,z), and
			// a step of (0,0,1) in (i,j,k) means a step of (-c,-c,1-c) in (x,y,z), where
			// c = 1/6.
			var x1:Number = x0 - i1 + G3; // Offsets for second corner in (x,y,z) coords
			var y1:Number = y0 - j1 + G3;
			var z1:Number = z0 - k1 + G3;
			var x2:Number = x0 - i2 + 2.0*G3; // Offsets for third corner in (x,y,z) coords
			var y2:Number = y0 - j2 + 2.0*G3;
			var z2:Number = z0 - k2 + 2.0*G3;
			var x3:Number = x0 - 1.0 + 3.0*G3; // Offsets for last corner in (x,y,z) coords
			var y3:Number = y0 - 1.0 + 3.0*G3;
			var z3:Number = z0 - 1.0 + 3.0*G3;
			// Work out the hashed gradient indices of the four simplex corners
			var ii:int = i & 255;
			var jj:int = j & 255;
			var kk:int = k & 255;
			var gi0:int = permMod12[ii+perm[jj+perm[kk]]];
			var gi1:int = permMod12[ii+i1+perm[jj+j1+perm[kk+k1]]];
			var gi2:int = permMod12[ii+i2+perm[jj+j2+perm[kk+k2]]];
			var gi3:int = permMod12[ii+1+perm[jj+1+perm[kk+1]]];
			// Calculate the contribution from the four corners
			var t0:Number = 0.6 - x0*x0 - y0*y0 - z0*z0;
			if (t0 < 0)
			{
				n0 = 0.0;
			}
			else
			{
				t0 *= t0;
				n0 = t0 * t0 * dot3(grad3[gi0], x0, y0, z0);
			}
			var t1:Number = 0.6 - x1*x1 - y1*y1 - z1*z1;
			if (t1 < 0)
			{
				n1 = 0.0;
			}
			else
			{
				t1 *= t1;
				n1 = t1 * t1 * dot3(grad3[gi1], x1, y1, z1);
			}
			var t2:Number = 0.6 - x2*x2 - y2*y2 - z2*z2;
			if (t2 < 0)
			{
				n2 = 0.0;
			}
			else
			{
				t2 *= t2;
				n2 = t2 * t2 * dot3(grad3[gi2], x2, y2, z2);
			}
			var t3:Number = 0.6 - x3*x3 - y3*y3 - z3*z3;
			if (t3 < 0)
			{
				n3 = 0.0;
			}
			else
			{
				t3 *= t3;
				n3 = t3 * t3 * dot3(grad3[gi3], x3, y3, z3);
			}
			// Add contributions from each corner to get the final noise value.
			// The result is scaled to stay just inside [-1,1]
			return 32.0*(n0 + n1 + n2 + n3);
		}
	}
}