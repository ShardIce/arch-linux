```text
Required parameter $sql_parts follows optional parameter $table_alias [zabbix.php:22 → require_once() → ZBase->run() → CSettingsHelper::getGlobal() → CSettingsHelper::loadParams() → API::getApiService() → CRegistryFactory->getObject() → CApiService->__construct() → CApiService->pk() → CApiService->getTableSchema() → CAutoloader->loadClass() → require() in include/classes/core/CAutoloader.php:77]
```

# Решение
#### Открываем "zabbix.local/include/classes/db/DB.php"

 // add output options
- $sql_parts = self::applyQueryOutputOptions($table_name, $options, $table_alias, $sql_parts);
+ $sql_parts = self::applyQueryOutputOptions($table_name, $options, $sql_parts, $table_alias);

 // add filter options
- $sql_parts = self::applyQueryFilterOptions($table_name, $options, $table_alias, $sql_parts);
+ $sql_parts = self::applyQueryFilterOptions($table_name, $options, $sql_parts, $table_alias);

 // add sort options
- $sql_parts = self::applyQuerySortOptions($table_name, $options, $table_alias, $sql_parts);
+ $sql_parts = self::applyQuerySortOptions($table_name, $options, $sql_parts, $table_alias);

 return $sql_parts;
 }
@@ -1006,13 +1006,13 @@ class DB {
 *
 * @param string $table_name
 * @param array $options
- * @param string $table_alias
 * @param array $sql_parts
+ * @param string $table_alias
 *
 * @return array
 */
- private static function applyQueryOutputOptions($table_name, array $options, $table_alias = null,
- array $sql_parts) {
+ private static function applyQueryOutputOptions($table_name, array $options, array $sql_parts,
+ $table_alias = null) {
 if ($options['countOutput']) {
 $sql_parts['select'][] = 'COUNT('.self::fieldId('*', $table_alias).') AS rowscount';
 }
@@ -1042,13 +1042,13 @@ class DB {
 *
 * @param string $table_name
 * @param array $options
- * @param string $table_alias
 * @param array $sql_parts
+ * @param string $table_alias
 *
 * @return array
 */
- private static function applyQueryFilterOptions($table_name, array $options, $table_alias = null,
- array $sql_parts) {
+ private static function applyQueryFilterOptions($table_name, array $options, array $sql_parts,
+ $table_alias = null) {
 $table_schema = self::getSchema($table_name);
 $pk = self::getPk($table_name);
 $pk_option = $pk.'s';
@@ -1149,12 +1149,12 @@ class DB {
 *
 * @param string $table_name
 * @param array $options
- * @param string $table_alias
 * @param array $sql_parts
+ * @param string $table_alias
 *
 * @return array
 */
- private static function applyQuerySortOptions($table_name, array $options, $table_alias = null, array $sql_parts) {
+ private static function applyQuerySortOptions($table_name, array $options, array $sql_parts, $table_alias = null) {
 $table_schema = self::getSchema($table_name);

 foreach ($options['sortfield'] as $index => $field_name) {