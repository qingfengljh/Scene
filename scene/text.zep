
/**
 * Text
 *
*/

namespace Scene;

/**
 * Scene\Text
 *
 * Provides utilities to work with texts
 */
abstract class Text
{
	/**
     * Random: Alphanumeric
     *
     * @var int
    */
	const RANDOM_ALNUM = 0;

	/**
     * Random: Alpha
     *
     * @var int
    */
	const RANDOM_ALPHA = 1;

	/**
     * Random: Hexdecimal
     *
     * @var int
    */
	const RANDOM_HEXDEC = 2;

	/**
     * Random: Numeric
     *
     * @var int
    */
	const RANDOM_NUMERIC = 3;

	/**
     * Random: No Zero
     *
     * @var int
    */
	const RANDOM_NOZERO = 4;

	/**
     * Converts strings to camelize style
     *
     *<code>
     *  echo \Scene\Text::camelize('coco_bongo'); //CocoBongo
     *</code>
     *
     * @param string $str
     * @return string
     * @throws Exception
     */
	public static function camelize(string! str)
	{
		//return str->camelize();
		var l, camelized, i;
		if typeof str !== "string" {
			throw new Exception("Invalid arguments supplied for camelize()");
		}
		
		let l = strlen(str);
		let camelized = "";

		let i = 0;
		while i < l {
			if i === 0 || chr(str[i]) === "-" || chr(str[i]) === "_" {
				if chr(str[i]) === '-' || chr(str[i]) === "_" {
					let i++;
				}

				if chr(str[i]) {
					let camelized .= strtoupper(chr(str[i]));
				} else {
					let camelized .= chr(0);
				}
			} else {
				let camelized .= strtolower(chr(str[i]));
			}
			
			let i++;
		}
		

        return camelized;
	}

	/**
     * Uncamelize strings which are camelized
     *
     *<code>
     *  echo \Scene\Text::uncamelize('CocoBongo'); //coco_bongo
     *</code>
     *
     * @param string $str
     * @return string
     * @throws Exception
     */
	public static function uncamelize(string! str) -> string
	{
		//return str->uncamelize();
		var l, uncamelized, i, ch;

		let l = strlen(str);
		let uncamelized = "";

		let i = 0;
		while i < l {
			let ch = str[i];

			if ch === 0 {
				break;
			}

			if ch >= 65 && ch <= 90 {
				if i > 0 {
					let uncamelized .= "_";
				}
				let uncamelized .= chr(ch + 32);
			} else {
				let uncamelized .= chr(str[i]);
			}

			let i++;
		}

		return uncamelized;

	}

	/**
     * Adds a number to a string or increment that number if it already is defined
     *
     *<code>
     *  echo \Scene\Text::increment("a"); // "a_1"
     *  echo \Scene\Text::increment("a_1"); // "a_2"
     *</code>
     *
     * @param string $str
     * @param string|null $separator
     * @return string
     * @throws Exception
     */
	public static function increment(string str, string separator = "_") -> string
	{
		var parts, number;

		let parts = explode(separator, str);

		if fetch number, parts[1] {
			let number++;
		} else {
			let number = 1;
		}

		return parts[0] . separator. number;
	}

	/**
     * Generates a random string based on the given type. Type is one of the RANDOM_* constants
     *
     *<code>
     *  echo \Scene\Text::random(Scene\Text::RANDOM_ALNUM); //"aloiwkqz"
     *</code>
     *
     * @param int $type
     * @param int|null $length
     * @return string
     * @throws Exception
     */
	public static function random(int type = 0, long length = 8) -> string
	{
		var pool, str = "";
		int end;

		switch type {

			case Text::RANDOM_ALPHA:
				let pool = array_merge(range("a", "z"), range("A", "Z"));
				break;

			case Text::RANDOM_HEXDEC:
				let pool = array_merge(range(0, 9), range("a", "f"));
				break;

			case Text::RANDOM_NUMERIC:
				let pool = range(0, 9);
				break;

			case Text::RANDOM_NOZERO:
				let pool = range(1, 9);
				break;

			default:
				// Default type \Scene\Text::RANDOM_ALNUM
				let pool = array_merge(range(0, 9), range("a", "z"), range("A", "Z"));
				break;
		}

		let end = count(pool) - 1;

		while strlen(str) < length {
			let str .= pool[mt_rand(0, end)];
		}

		return str;
	}

	/**
     * Check if a string starts with a given string
     *
     *<code>
	 *  echo Scene\Text::startsWith("Hello", "He"); // true
	 *  echo Scene\Text::startsWith("Hello", "he", false); // false
	 *  echo Scene\Text::startsWith("Hello", "he"); // true
     *</code>
     *
     * @param string $str
     * @param string $start
     * @param boolean|null $ignoreCase
     * @return boolean
     * @throws Exception
     */
	public static function startsWith(string str, string start, boolean ignoreCase = true) -> boolean
	{
		return starts_with(str, start, ignoreCase);
	}

	/**
     * Check if a string ends with a given string
     *
     *<code>
     *  echo Scene\Text::endsWith("Hello", "llo"); // true
	 *  echo Scene\Text::endsWith("Hello", "LLO", false); // false
	 *  echo Scene\Text::endsWith("Hello", "LLO"); // true
     *</code>
     *
     * @param string $str
     * @param string $end
     * @param boolean|null $ignoreCase
     * @return boolean
     * @throws Exception
     */
	public static function endsWith(string str, string end, boolean ignoreCase = true) -> boolean
	{
		return ends_with(str, end, ignoreCase);
	}

	/**
     * Lowercases a string, this function makes use of the mbstring extension if available
     *
     * <code>
	 *    echo Scene\Text::lower("HELLO"); // hello
	 * </code>
	 * 
     * @param string! $str
     * @param string $encoding
     * @return string
     * @throws Exception
     */
	public static function lower(string! str, string! encoding = "UTF-8") -> string
	{
		/**
		 * 'lower' checks for the mbstring extension to make a correct lowercase transformation
		 */
		if function_exists("mb_strtolower") {
			return mb_strtolower(str, encoding);
		}
		return strtolower(str);
	}

	/**
     * Uppercases a string, this function makes use of the mbstring extension if available
     *
     * <code>
	 *    echo Scene\Text::upper("hello"); // HELLO
	 * </code>
     * @param string! $str
     * @return string
     * @throws Exception
     */
	public static function upper(string! str, string! encoding = "UTF-8") -> string
	{
		/**
		 * 'upper' checks for the mbstring extension to make a correct lowercase transformation
		 */
		if function_exists("mb_strtoupper") {
			return mb_strtoupper(str, encoding);
		}
		return strtoupper(str);
	}

	/**
	 * Reduces multiple slashes in a string to single slashes
	 *
	 * <code>
	 *    echo Scene\Text::reduceSlashes("foo//bar/baz"); // foo/bar/baz
	 *    echo Scene\Text::reduceSlashes("http://foo.bar///baz/buz"); // http://foo.bar/baz/buz
	 * </code>
	 *
	 * @param  string $str
	 * @return  string
	 */
	public static function reduceSlashes(string str) -> string
	{
		return preg_replace("#(?<!:)//+#", "/", str);
	}

	/**
	 * Concatenates strings using the separator only once without duplication in places concatenation
	 *
	 * <code>
	 *    $str = Scene\Text::concat("/", "/tmp/", "/folder_1/", "/folder_2", "folder_3/");
	 *    echo $str; // /tmp/folder_1/folder_2/folder_3/
	 * </code>
	 *
	 * @param string separator
	 * @param string a
	 * @param string b
	 * @param string ...N
	 */
	//public static function concat(string! separator, string! a, string! b) -> string
	public static function concat() -> string
	{
		/**
		 * TODO:
		 * Remove after solve https://github.com/Scene/zephir/issues/938,
		 * and also replace line 214 to 213
		 */
		var separator, a, b;
		let separator = func_get_arg(0),
			a = func_get_arg(1),
			b = func_get_arg(2);
		//END

		var c;

		if func_num_args() > 3 {
			for c in array_slice(func_get_args(), 3) {
				let b = rtrim(b, separator) . separator . ltrim(c, separator);
			}
		}

		return rtrim(a, separator) . separator . ltrim(b, separator);
	}
}