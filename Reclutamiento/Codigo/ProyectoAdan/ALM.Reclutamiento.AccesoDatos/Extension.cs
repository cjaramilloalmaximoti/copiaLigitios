namespace ALM.Empresa.AccesoDatos
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Data.Common;
    using System.IO;
    using System.Linq;
    using System.Linq.Expressions;
    using System.Reflection;

    public static class Extension
    {
        #region DataReader to List

        /// <summary>
        /// Método estático para convertir un DataReader a una lista genérica.
        /// </summary>
        /// <typeparam name="T">Tipo de clase a generar lista</typeparam>
        /// <param name="reader">DataReader</param>
        /// <returns>Lista</returns>
        public static List<T> DataReaderMapearALista<T>(this IDataReader reader) where T : class
        {
            List<T> results = null;
            Func<DbDataReader, T> readRow = null;
            try
            {
                results = new List<T>();
                readRow = DarFuncionalidadDataReader<T>((DbDataReader)reader);
                while (reader.Read())
                {
                    results.Add(readRow((DbDataReader)reader));
                }
                return results;
            }
            finally
            {
                results = null;
                readRow = null;
            }
        }

        /// <summary>
        /// Método estático que genera la función para obtener información de cada elemento del DataReader y establecer el valor en la propiedad que le corresponda de la clase.
        /// </summary>
        /// <typeparam name="T">Tipo de clase a generar lista</typeparam>
        /// <param name="reader">DataReader</param>
        /// <returns>Lista</returns>
        private static Func<DbDataReader, T> DarFuncionalidadDataReader<T>(DbDataReader reader) where T : class
        {
            Delegate resDelegate = null;
            List<ColumnaDataReader> readerColumns = null;
            ParameterExpression readerParam = null;
            MethodInfo readerGetValue = null;
            MemberExpression dbNullExp = null;
            List<MemberBinding> memberBindings = null;
            object defaultValue = null;
            ConstantExpression indexExpression = null;
            MethodCallExpression getValueExp = null;
            BinaryExpression testExp = null;
            UnaryExpression ifTrue = null;
            UnaryExpression ifFalse = null;
            MemberInfo mi = null;
            MemberBinding mb = null;
            NewExpression newItem = null;
            MemberInitExpression memberInit = null;
            Expression<Func<DbDataReader, T>> lambda = null;
            FieldInfo dbNullValue = null;
            ColumnaDataReader columna = null;
            try
            {
                readerColumns = (from DataRow row in reader.GetSchemaTable().Rows
                                 select new ColumnaDataReader
                                 {
                                     NombreColumna = row["ColumnName"].ToString()
                                 }).ToList();

                // Determina la información del reader
                readerParam = Expression.Parameter(typeof(DbDataReader), "reader");
                readerGetValue = typeof(DbDataReader).GetMethod("GetValue");

                // Crea una expresion constante para usar el DBNull
                dbNullValue = typeof(System.DBNull).GetField("Value");
                dbNullExp = Expression.Field(expression: null, type: typeof(System.DBNull), fieldName: "Value");
                //dbNullExp = Expression.Field(Expression.Parameter(typeof(System.DBNull), "System.DBNull"), dbNullValue); // framework 3.5


                // Itera a traves de las propiedades y crea la expresión MemberBinding para cada propiedad
                memberBindings = new List<MemberBinding>();
                foreach (var prop in typeof(T).GetProperties())
                {
                    // Determina el valor default de la propiedad
                    defaultValue = null;
                    if (prop.PropertyType.IsValueType)
                        defaultValue = Activator.CreateInstance(prop.PropertyType);
                    else if (prop.PropertyType.Name.ToLower().Equals("string"))
                        defaultValue = string.Empty;

                    columna = readerColumns.Find(r => r.NombreColumna.ToUpper().Equals(prop.Name.ToUpper()) || r.NombreColumnaSinGuion.ToUpper().Equals(prop.Name.ToUpper()));
                    if (columna != null)
                    {
                        // Construye la expresion Call para recuperar los datos del reader
                        indexExpression = Expression.Constant(reader.GetOrdinal(columna.NombreColumna));
                        indexExpression = indexExpression != null ? indexExpression : Expression.Constant(reader.GetOrdinal(columna.NombreColumnaSinGuion));
                        getValueExp = Expression.Call(readerParam, readerGetValue, new Expression[] { indexExpression });

                        // Crea la expresion condicional para asegurse que el value != DBNull.Value del reader
                        testExp = Expression.NotEqual(dbNullExp, getValueExp);
                        ifTrue = Expression.Convert(getValueExp, prop.PropertyType);
                        ifFalse = Expression.Convert(Expression.Constant(defaultValue), prop.PropertyType);

                        // Crea la expresion Bind para ligar  el valor del reader al valor de la propiedad
                        mi = typeof(T).GetMember(prop.Name)[0];
                        mb = Expression.Bind(mi, Expression.Condition(testExp, ifTrue, ifFalse));
                        memberBindings.Add(mb);
                    }
                }

                // Crea una expresión MemberInit para el elemento con los miembros bindings
                newItem = Expression.New(typeof(T));
                memberInit = Expression.MemberInit(newItem, memberBindings);
                lambda = Expression.Lambda<Func<DbDataReader, T>>(memberInit, new ParameterExpression[] { readerParam });
                resDelegate = lambda.Compile();
                return (Func<DbDataReader, T>)resDelegate;
            }
            finally
            {
                resDelegate = null;
                readerColumns = null;
                readerParam = null;
                readerGetValue = null;
                dbNullExp = null;
                memberBindings = null;
                defaultValue = null;
                indexExpression = null;
                getValueExp = null;
                testExp = null;
                ifTrue = null;
                ifFalse = null;
                mi = null;
                mb = null;
                newItem = null;
                memberInit = null;
                lambda = null;
                dbNullValue = null;
            }
        }

        #endregion

        #region DataReader to XML

        /// <summary>
        /// Método estático para convertir los DataTable's, contenidos en un DataSet, en un XML.
        /// </summary>
        /// <param name="dts">DataSet</param>
        /// <returns>XML</returns>
        public static string DataSetMapToXML(this DataSet dts)
        {
            StringWriter writer = null;
            try
            {
                if (dts != null && dts.Tables.Count > 0)
                {
                    dts.DataSetName = "Lista";
                    writer = new System.IO.StringWriter();
                    foreach (DataTable table in dts.Tables)
                    {
                        table.TableName = "Item" + dts.Tables.IndexOf(table);
                        table.WriteXml(writer, XmlWriteMode.IgnoreSchema, false);
                    }
                    return writer.ToString().Replace("\r\n ", string.Empty).Replace("\r\n", string.Empty).Replace(">   <", "><").Replace(">  <", "><").Replace("> <", "><");
                }
                return null;
            }
            finally
            {
                writer = null;
            }
        }

        #endregion

        #region DataReader to List

        /// <summary>
        /// Método estático para convertir un DataTable a una lista genérica.
        /// </summary>
        /// <typeparam name="T">Tipo de clase a generar lista</typeparam>
        /// <param name="dataTable">DataTable</param>
        /// <returns>Lista</returns>
        public static List<T> DataTableMapToList<T>(this DataTable dataTable) where T : class
        {
            List<T> results = null;
            Func<DataRow, T> readRow = null;
            try
            {
                results = new List<T>();
                readRow = DarFuncionalidadDataTablePorRow<T>(dataTable, null);
                foreach (DataRow row in dataTable.Rows)
                {
                    results.Add(readRow(row));
                }
                return results;
            }
            finally
            {
                results = null;
                readRow = null;
            }
        }

        /// <summary>
        /// Método estático que genera la función para obtener información de cada elemento del DataTable y establecer el valor en la propiedad que le corresponda de la clase.
        /// </summary>
        /// <typeparam name="T">Tipo de clase a generar lista</typeparam>
        /// <param name="dataTable">DataTable</param>
        /// <param name="row">Renglon actual a convertir</param>
        /// <returns>Lista</returns>
        private static Func<DataRow, T> DarFuncionalidadDataTablePorRow<T>(DataTable dataTable, DataRow row) where T : class
        {
            Delegate resDelegate = null;
            List<ColumnaDataReader> readerColumns = null;
            ParameterExpression readerParam = null;
            MethodInfo readerGetValue = null;
            MemberExpression dbNullExp = null;
            List<MemberBinding> memberBindings = null;
            object defaultValue = null;
            ConstantExpression indexExpression = null;
            MethodCallExpression getValueExp = null;
            BinaryExpression testExp = null;
            UnaryExpression ifTrue = null;
            UnaryExpression ifFalse = null;
            MemberInfo mi = null;
            MemberBinding mb = null;
            NewExpression newItem = null;
            MemberInitExpression memberInit = null;
            Expression<Func<DataRow, T>> lambda = null;
            FieldInfo dbNullValue = null;
            ColumnaDataReader columna = null;
            try
            {
                readerColumns = (from DataColumn column in dataTable.Columns
                                 select new ColumnaDataReader
                                 {
                                     NombreColumna = column.ColumnName
                                 }).ToList();

                // Determina la información del reader
                readerParam = Expression.Parameter(typeof(DataRow), "reader");
                readerGetValue = typeof(DataRow).GetMethod("get_Item", new Type[] { typeof(int) });

                // Crea una expresion constante para usar el DBNull
                dbNullValue = typeof(System.DBNull).GetField("Value");
                dbNullExp = Expression.Field(expression: null, type: typeof(System.DBNull), fieldName: "Value");
                //dbNullExp = Expression.Field(Expression.Parameter(typeof(System.DBNull), "System.DBNull"), dbNullValue); // framework 3.5


                // Itera a traves de las propiedades y crea la expresión MemberBinding para cada propiedad
                memberBindings = new List<MemberBinding>();
                foreach (var prop in typeof(T).GetProperties())
                {
                    // Determina el valor default de la propiedad
                    defaultValue = null;
                    if (prop.PropertyType.IsValueType)
                        defaultValue = Activator.CreateInstance(prop.PropertyType);
                    else if (prop.PropertyType.Name.ToLower().Equals("string"))
                        defaultValue = string.Empty;

                    columna = readerColumns.Find(r => r.NombreColumna.ToUpper().Equals(prop.Name.ToUpper()) || r.NombreColumnaSinGuion.ToUpper().Equals(prop.Name.ToUpper()));
                    if (columna != null)
                    {
                        // Construye la expresion Call para recuperar los datos del reader
                        indexExpression = Expression.Constant(dataTable.Columns[columna.NombreColumna].Ordinal);
                        indexExpression = indexExpression != null ? indexExpression : Expression.Constant(dataTable.Columns[columna.NombreColumnaSinGuion].Ordinal);
                        getValueExp = Expression.Call(readerParam, readerGetValue, new Expression[] { indexExpression });

                        // Crea la expresion condicional para asegurse que el value != DBNull.Value del reader
                        testExp = Expression.NotEqual(dbNullExp, getValueExp);
                        ifTrue = Expression.Convert(getValueExp, prop.PropertyType);
                        ifFalse = Expression.Convert(Expression.Constant(defaultValue), prop.PropertyType);

                        // Crea la expresion Bind para ligar  el valor del reader al valor de la propiedad
                        mi = typeof(T).GetMember(prop.Name)[0];
                        mb = Expression.Bind(mi, Expression.Condition(testExp, ifTrue, ifFalse));
                        memberBindings.Add(mb);
                    }
                }

                // Crea una expresión MemberInit para el elemento con los miembros bindings
                newItem = Expression.New(typeof(T));
                memberInit = Expression.MemberInit(newItem, memberBindings);
                lambda = Expression.Lambda<Func<DataRow, T>>(memberInit, new ParameterExpression[] { readerParam });
                resDelegate = lambda.Compile();
                return (Func<DataRow, T>)resDelegate;
            }
            finally
            {
                resDelegate = null;
                readerColumns = null;
                readerParam = null;
                readerGetValue = null;
                dbNullExp = null;
                memberBindings = null;
                defaultValue = null;
                indexExpression = null;
                getValueExp = null;
                testExp = null;
                ifTrue = null;
                ifFalse = null;
                mi = null;
                mb = null;
                newItem = null;
                memberInit = null;
                lambda = null;
                dbNullValue = null;
            }
        }

        #endregion
    }
}