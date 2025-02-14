package minko.math;
using Std;

class HashCore {

    /**
	 * Compute string hash using djb2 algorithm.
	 *
	 * Has a good balance of being extremely fast, while providing a reasonable distribution of hash values.
	 * @see http://www.cse.yorku.ca/~oz/hash.html
	 */
    public static function djb2(s:String):Int {
        var hash = 5381;
        for (i in 0...s.length) {
            hash = ((hash << 5) + hash) + s.charCodeAt(i);
        }
        return hash;
    }

    /**
	 * Compute string hash using sdbm algorithm.
	 *
	 * This algorithm was created for sdbm (a public-domain reimplementation of ndbm) database library.
	 * It was found to do well in scrambling bits, causing better distribution of the keys and fewer splits.
	 * It also happens to be a good general hashing function with good distribution.
	 * @see http://www.cse.yorku.ca/~oz/hash.html
	 */
    public static function sdbm(s:String):Int {
        var hash = 0;
        for (i in 0...s.length) {
            hash = s.charCodeAt(i) + (hash << 6) + (hash << 16) - hash;
        }
        return hash;
    }

    /**
	 * Java's String.hashCode() method implemented in Haxe.
	 * @see http://docs.oracle.com/javase/1.4.2/docs/api/java/lang/String.html#hashCode%28%29
	 */
    public static function javaHashCode(s:String):Int {
        var hash = 0;
        if (s.length == 0) return hash;
        for (i in 0...s.length) {
            hash = ((hash << 5) - hash) + s.charCodeAt(i);
            hash = hash & hash; // Convert to 32bit integer
        }
        return hash;
    }

}
class Random {
    /**
	 * (a Mersenne prime M31) modulus constant = 2^31 - 1 = 0x7ffffffe
	 */
    private inline static var MPM = 2147483647.0;

    /**
	 * (a primitive root modulo M31)
	 */
    private inline static var MINSTD = 16807.0;

    /**
	 * Make a non deterministic random seed using standard libraries.
	 * @return Non deterministic random seed.
	 */
    public static function makeRandomSeed():Int {
        return Math.floor(Math.random() * MPM);
    }

    /**
	 * Park-Miller-Carta algorithm.
	 * @see <a href="http://lab.polygonal.de/?p=162">http://lab.polygonal.de/?p=162</a>
	 * @see <a href="http://code.google.com/p/polygonal/source/browse/trunk/src/lib/de/polygonal/core/math/random/ParkMiller.hx?r=547">http://code.google.com/p/polygonal/source/browse/trunk/src/lib/de/polygonal/core/math/random/ParkMiller.hx?r=547</a>
	 * @see <a href="http://en.wikipedia.org/wiki/Lehmer_random_number_generator">http://en.wikipedia.org/wiki/Lehmer_random_number_generator</a>
	 * @return Returns the next pseudo-random int value.
	 */
    public static inline function nextParkMiller(seed:Int):Int {
        return Math.floor((seed * MINSTD) % MPM);
    }

    /**
	 * <p>A Park-Miller-Carta PRNG (pseudo random number generator).</p>
	 * <p>Integer implementation, using only 32 bit integer maths and no divisions.</p>
	 * @see <a href="https://github.com/polygonal/core/blob/dev/src/de/polygonal/core/math/random/ParkMiller31.hx">POLYGONAL - A HAXE LIBRARY FOR GAME DEVELOPERS</a>
	 * @see <a href="http://www.firstpr.com.au/dsp/rand31/rand31-park-miller-carta.cc.txt" target="_blank">http://www.firstpr.com.au/dsp/rand31/rand31-park-miller-carta.cc.txt</a>
	 * @see <a href="http://en.wikipedia.org/wiki/Park%E2%80%93Miller_random_number_generator" target="_blank">Park-Miller random number generator</a>.
	 * @see <a href="http://lab.polygonal.de/?p=162" target="_blank">A good Pseudo-Random Number Generator (PRNG)</a>.
	 */
    public static function nextParkMiller31(seed:Int):Int {
        var lo:Int = 16807 * (seed & 0xffff);
        var hi:Int = 16807 * (seed >>> 16);
        lo += (hi & 0x7fff) << 16;
        lo += hi >>> 15;
        if (lo > 0x7fffffff) lo -= 0x7fffffff;
        return lo;
    }

    /**
	 * Linear congruential generator using GLIBC constants.
     *
	 * @see <a href="http://en.wikipedia.org/wiki/Linear_congruential_generator">http://en.wikipedia.org/wiki/Linear_congruential_generator</a>
	 * @see <a href="https://github.com/aduros/flambe/blob/master/src/flambe/util/Random.hx">https://github.com/aduros/flambe/blob/master/src/flambe/util/Random.hx</a>
	 * @return Returns an integer in [0, INT_MAX)
     */
    public static inline function nextLCG(seed:Int):Int {
        // These constants borrowed from glibc
        // Force float multiplication here to avoid overflow in Flash (and keep parity with JS)
        return Math.floor((1103515245.0 * seed + 12345) % MPM) ;
    }

    /**
	 * Returns the pseudo-random double value x in the range 0 <= x < 1.
	 */
    public static inline function toFloat(seed:Int):Float {
        return seed / MPM;
    }

    /**
	 * Returns a pseudo-random boolean value (coin flip).
	 */
    public static inline function toBool(seed:Int):Bool {
        return toFloat(seed) > 0.5;
    }

    /**
	 * Returns a pseudo-random double value x in the range min <= x <= max.
	 */
    public static inline function toFloatRange(seed:Int, min:Float, max:Float):Float {
        return min + (max - min) * toFloat(seed);
    }

    /**
	 * Returns a pseudo-random integral value x in the range min <= x <= max.
	 */
    public static inline function toIntRange(seed:Int, min:Int, max:Int):Int {
        return Math.round((min - 0.4999) + ((max + 0.4999) - (min - 0.4999)) * toFloat(seed));
    }

    /**
	 * Converts a string to a seed.
	 * Lets you use words as seeds.
	 */
    public static function stringToSeed(s:String):Int {
        return Math.floor(HashCore.djb2(s) % MPM);
    }
}
