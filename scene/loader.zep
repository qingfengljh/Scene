
/**
 * Loader
 *
*/

namespace Scene;

use Scene\Events\ManagerInterface;
use Scene\Events\EventsAwareInterface;
use Scene\Text;

/**
 * Scene\Loader
 *
 * This component helps to load your project classes automatically based on some conventions
 *
 *<code>
 * //Creates the autoloader
 * $loader = new Loader();
 *
 * //Register some namespaces
 * $loader->registerNamespaces(array(
 *   'Example\Base' => 'vendor/example/base/',
 *   'Example\Adapter' => 'vendor/example/adapter/',
 *   'Example' => 'vendor/example/'
 * ));
 *
 * //register autoloader
 * $loader->register();
 *
 * //Requiring this class will automatically include file vendor/example/adapter/Some.php
 * $adapter = Example\Adapter\Some();
 *</code>
 */
class Loader implements EventsAwareInterface
{
	/**
     * Events Manager
     *
     * @var Scene\Events\ManagerInterface|null
     * @access protected
    */
	protected _eventsManager = null;

	/**
     * Found Path
     *
     * @var string|null
     * @access protected
    */
	protected _foundPath = null;

	/**
     * Checked Path
     *
     * @var string|null
     * @access protected
    */
	protected _checkedPath = null;

	/**
     * Prefixes
     *
     * @var array|null
     * @access protected
    */
	protected _prefixes = null;

	/**
     * Classes
     *
     * @var array|null
     * @access protected
    */
	protected _classes = null;

	/**
     * Extensions
     *
     * @var array
     * @access protected
    */
	protected _extensions;

	/**
     * Namespaces
     *
     * @var array|null
     * @access protected
    */
	protected _namespaces = null;

	/**
     * Directories
     *
     * @var array|null
     * @access protected
    */
	protected _directories = null;

	/**
     * Registered
     *
     * @var boolean
     * @access protected
    */
	protected _registered = false;

	/**
	 * Scene\Loader constructor
	 */
	public function __construct()
	{
		let this->_extensions = ["php"];
	}

	/**
     * Sets the events manager
     *
     * @param \Scene\Events\ManagerInterface $eventsManager
     * @throws \Scene\Loader\Exception
     */
	public function setEventsManager(<ManagerInterface> eventsManager)
	{
		let this->_eventsManager = eventsManager;
	}

	/**
     * Returns the internal event manager
     *
     * @return \Scene\Events\ManagerInterface|null
     */
	public function getEventsManager() -> <ManagerInterface>
	{
		return this->_eventsManager;
	}

	/**
     * Sets an array of extensions that the loader must try in each attempt to locate the file
     *
     * @param array! $extensions
     * @return \Scene\Loader
     * @throws \Scene\Loader\Exception
     */
	public function setExtensions(array! extensions) -> <Loader>
	{
		let this->_extensions = extensions;
		return this;
	}

	/**
     * Return file extensions registered in the loader
     *
     * @return array
     */
	public function getExtensions() -> array
	{
		return this->_extensions;
	}

	/**
     * Register namespaces and their related directories
     *
     * @param array! $namespaces
     * @param boolean|null $merge
     * @return \Scene\Loader
     * @throws \Scene\Loader\Exception
     */
	public function registerNamespaces(array! namespaces, boolean merge = false) -> <Loader>
	{
		var currentNamespaces, mergedNamespaces;

		if merge {
			let currentNamespaces = this->_namespaces;
			if typeof currentNamespaces == "array" {
				let mergedNamespaces = array_merge(currentNamespaces, namespaces);
			} else {
				let mergedNamespaces = namespaces;
			}
			let this->_namespaces = mergedNamespaces;
		} else {
			let this->_namespaces = namespaces;
		}

		return this;
	}

	/**
     * Return current namespaces registered in the autoloader
     *
     * @return array|null
     */
	public function getNamespaces() -> array
	{
		return this->_namespaces;
	}

	/**
     * Register directories on which "not found" classes could be found
     *
     * @param array $prefixes
     * @param boolean|null $merge
     * @return \Scene\Loader
     * @throws \Scene\Loader\Exception
     */
	public function registerPrefixes(array! prefixes, boolean merge = false) -> <Loader>
	{
		var currentPrefixes, mergedPrefixes;

		if merge {
			let currentPrefixes = this->_prefixes;
			if typeof currentPrefixes == "array" {
				let mergedPrefixes = array_merge(currentPrefixes, prefixes);
			} else {
				let mergedPrefixes = prefixes;
			}
			let this->_prefixes = mergedPrefixes;
		} else {
			let this->_prefixes = prefixes;
		}
		return this;
	}

	/**
     * Return current prefixes registered in the autoloader
     *
     * @param array|null
     */
	public function getPrefixes() -> array
	{
		return this->_prefixes;
	}

	/**
     * Register directories on which "not found" classes could be found
     *
     * @param array $directories
     * @param boolean|null $merge
     * @return \Scene\Loader
     * @throws \Scene\Loader\Exception
     */
	public function registerDirs(array! directories, boolean merge = false) -> <Loader>
	{
		var currentDirectories, mergedDirectories;

		if merge {
			let currentDirectories = this->_directories;
			if typeof currentDirectories == "array" {
				let mergedDirectories = array_merge(currentDirectories, directories);
			} else {
				let mergedDirectories = directories;
			}
			let this->_directories = mergedDirectories;
		} else {
			let this->_directories = directories;
		}
		return this;
	}

	/**
     * Return current directories registered in the autoloader
     *
     * @return array|null
     */
	public function getDirs() -> array
	{
		return this->_directories;
	}

	/**
     * Register classes and their locations
     *
     * @param array $classes
     * @param boolean|null $merge
     * @return \Scene\Loader
     * @throws \Scene\Loader\Exception
     */
	public function registerClasses(array! classes, boolean merge = false) -> <Loader>
	{
		var mergedClasses, currentClasses;

		if merge {
			let currentClasses = this->_classes;
			if typeof currentClasses == "array" {
				let mergedClasses = array_merge(currentClasses, classes);
			} else {
				let mergedClasses = classes;
			}
			let this->_classes = mergedClasses;
		} else {
			let this->_classes = classes;
		}
		return this;
	}

	/**
     * Return the current class-map registered in the autoloader
     *
     * @return array|null
     */
	public function getClasses() -> array
	{
		return this->_classes;
	}

	/**
     * Register the autoload method
     *
     * @return \Scene\Loader
     */
	public function register() -> <Loader>
	{
		if this->_registered === false {
			spl_autoload_register([this, "autoLoad"]);
			let this->_registered = true;
		}
		return this;
	}

	/**
     * Unregister the autoload method
     *
     * @return \Scene\Loader
     */
	public function unregister() -> <Loader>
	{
		if this->_registered === true {
			spl_autoload_unregister([this, "autoLoad"]);
			let this->_registered = false;
		}
		return this;
	}

	/**
     * Makes the work of autoload registered classes
     *
     * @param string! $className
     * @return boolean
     */
	public function autoLoad(string! className) -> boolean
	{
		var eventsManager, classes, extensions, filePath, ds, fixedDirectory,
			prefixes, directories, namespaceSeparator, namespaces, nsPrefix,
			directory, fileName, extension, prefix, dsClassName, nsClassName;

		let eventsManager = this->_eventsManager;
		if typeof eventsManager == "object" {
			eventsManager->fire("loader:beforeCheckClass", this, className);
		}

		/**
		 * First we check for static paths for classes
		 */
		let classes = this->_classes;
		if typeof classes == "array" {
			if fetch filePath, classes[className] {
				if typeof eventsManager == "object" {
					let this->_foundPath = filePath;
					eventsManager->fire("loader:pathFound", this, filePath);
				}
				require filePath;
				return true;
			}
		}

		let extensions = this->_extensions;

		let ds = DIRECTORY_SEPARATOR,
			namespaceSeparator = "\\";

		/**
		 * Checking in namespaces
		 */
		let namespaces = this->_namespaces;
		if typeof namespaces == "array" {

			for nsPrefix, directory in namespaces {

				/**
				 * The class name must start with the current namespace
				 */
				if Text::startsWith(className, nsPrefix) {

					/**
					 * Append the namespace separator to the prefix
					 */
					let fileName = substr(className, strlen(nsPrefix . namespaceSeparator));
					let fileName = str_replace(namespaceSeparator, ds, fileName);

					if fileName {

						/**
						 * Add a trailing directory separator if the user forgot to do that
						 */
						let fixedDirectory = rtrim(directory, ds) . ds;

						for extension in extensions {

							let filePath = fixedDirectory . fileName . "." . extension;

							/**
							 * Check if a events manager is available
							 */
							if typeof eventsManager == "object" {
								let this->_checkedPath = filePath;
								eventsManager->fire("loader:beforeCheckPath", this);
							}

							/**
							 * This is probably a good path, let's check if the file exists
							 */
							if is_file(filePath) {

								if typeof eventsManager == "object" {
									let this->_foundPath = filePath;
									eventsManager->fire("loader:pathFound", this, filePath);
								}

								/**
								 * Simulate a require
								 */
								require filePath;

								/**
								 * Return true mean success
								 */
								return true;
							}
						}
					}
				}
			}
		}

		/**
		 * Checking in prefixes
		 */
		let prefixes = this->_prefixes;
		if typeof prefixes == "array" {

			for prefix, directory in prefixes {

				/**
				 * The class name starts with the prefix?
				 */
				if Text::startsWith(className, prefix) {

					/**
					 * Get the possible file path
					 */
					let fileName = str_replace(prefix . namespaceSeparator, "", className);
					let fileName = str_replace(prefix . "_", "", fileName);
					let fileName = str_replace("_", ds, fileName);

					if fileName {

						/**
						 * Add a trailing directory separator if the user forgot to do that
						 */
						let fixedDirectory = rtrim(directory, ds) . ds;

						for extension in extensions {

							let filePath = fixedDirectory . fileName . "." . extension;

							if typeof eventsManager == "object" {
								let this->_checkedPath = filePath;
								eventsManager->fire("loader:beforeCheckPath", this, filePath);
							}

							if is_file(filePath) {

								/**
								 * Call 'pathFound' event
								 */
								if typeof eventsManager == "object" {
									let this->_foundPath = filePath;
									eventsManager->fire("loader:pathFound", this, filePath);
								}

								require filePath;
								return true;
							}
						}
					}
				}
			}
		}

		/**
		 * Change the pseudo-separator by the directory separator in the class name
		 */
		let dsClassName = str_replace("_", ds, className);

		/**
		 * And change the namespace separator by directory separator too
		 */
		let nsClassName = str_replace("\\", ds, dsClassName);

		/**
		 * Checking in directories
		 */
		let directories = this->_directories;
		if typeof directories == "array" {

			for directory in directories {

				/**
				 * Add a trailing directory separator if the user forgot to do that
				 */
				let fixedDirectory = rtrim(directory, ds) . ds;

				for extension in extensions {

					/**
					 * Create a possible path for the file
					 */
					let filePath = fixedDirectory . nsClassName . "." . extension;

					if typeof eventsManager == "object" {
						let this->_checkedPath = filePath;
						eventsManager->fire("loader:beforeCheckPath", this, filePath);
					}

					/**
					 * Check in every directory if the class exists here
					 */
					if is_file(filePath) {

						/**
						 * Call 'pathFound' event
						 */
						if typeof eventsManager == "object" {
							let this->_foundPath = filePath;
							eventsManager->fire("loader:pathFound", this, filePath);
						}

						/**
						 * Simulate a require
						 */
						require filePath;

						/**
						 * Return true meaning success
						 */
						return true;
					}
				}
			}
		}

		/**
		 * Call 'afterCheckClass' event
		 */
		if typeof eventsManager == "object" {
			eventsManager->fire("loader:afterCheckClass", this, className);
		}

		/**
		 * Cannot find the class, return false
		 */
		return false;
	}

	/**
     * Get the path when a class was found
     *
     * @return string|null
     */
	public function getFoundPath() -> string
	{
		return this->_foundPath;
	}

	/**
     * Get the path the loader is checking for a path
     *
     * @return string|null
     */
	public function getCheckedPath() -> string
	{
		return this->_checkedPath;
	}
}