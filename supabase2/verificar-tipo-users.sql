-- Verificar el tipo REAL de la columna id en users
SELECT 
  table_name,
  column_name, 
  data_type,
  udt_name
FROM information_schema.columns
WHERE table_name = 'users' 
  AND column_name = 'id';
