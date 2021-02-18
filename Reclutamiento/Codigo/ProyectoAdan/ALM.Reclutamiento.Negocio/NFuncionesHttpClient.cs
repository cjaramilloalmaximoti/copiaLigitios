using ALM.Empresa.Entidades;
using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;

namespace ALM.Empresa.Negocio
{
    public class NFuncionesHttpClient
    {
        private object newItem = null;

        public object NewItem
        {
            get
            {
                return newItem;
            }

            set
            {
                newItem = value;
            }
        }

        public async Task ObtenerVoid(string consulta, int idEmpresa)
        {
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(EClaseEstatica.LstParametro.Find(x => x.Nombre == "URLServicio").Valor);
                client.DefaultRequestHeaders.Accept.Clear();
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                // HTTP GET
                HttpResponseMessage response = await client.GetAsync(consulta);
                if (response.IsSuccessStatusCode)
                {
                }

            }
        }

        public async Task ObtenerEntidad<T>(string consulta, int idEmpresa) where T : class
        {
            using (var client = new HttpClient())
            {
                NewItem = null;
                client.BaseAddress = new Uri(EClaseEstatica.LstParametro.Find(x => x.Nombre == "URLServicio").Valor);
                client.DefaultRequestHeaders.Accept.Clear();
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                // HTTP GET
                HttpResponseMessage response = await client.GetAsync(consulta);
                if (response.IsSuccessStatusCode)
                {
                    newItem = await response.Content.ReadAsAsync<T>();
                }
            }
        }

        public async Task ObtenerListaEntidad<T>(string consulta, int idEmpresa) where T : class
        {
            using (var client = new HttpClient())
            {
                NewItem = null;
                client.BaseAddress = new Uri(EClaseEstatica.LstParametro.Find(x => x.Nombre == "URLServicio").Valor);
                client.DefaultRequestHeaders.Accept.Clear();
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                // HTTP GET
                HttpResponseMessage response = await client.GetAsync(consulta);
                if (response.IsSuccessStatusCode)
                {
                    newItem = await response.Content.ReadAsAsync<List<T>>();
                }
            }
        }

        public async Task Insertar<T>(string consulta, object objInsertar, int idEmpresa)
        {
            using (var client = new HttpClient())
            {
                NewItem = null;
                client.BaseAddress = new Uri(EClaseEstatica.LstParametro.Find(x => x.Nombre == "URLServicio").Valor);
                client.DefaultRequestHeaders.Accept.Clear();
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                // HTTP POST
                HttpResponseMessage response = await client.PostAsJsonAsync(consulta, objInsertar);
                if (response.IsSuccessStatusCode)
                {
                    newItem = await response.Content.ReadAsAsync<T>();
                }
            }
        }

        public async Task Actualizar<T>(string consulta, object objInsertar, int idEmpresa)
        {
            using (var client = new HttpClient())
            {
                NewItem = null;
                client.BaseAddress = new Uri(EClaseEstatica.LstParametro.Find(x => x.Nombre == "URLServicio").Valor);
                client.DefaultRequestHeaders.Accept.Clear();
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                // HTTP PUT
                HttpResponseMessage response = await client.PutAsJsonAsync(consulta, objInsertar);
                if (response.IsSuccessStatusCode)
                {
                    newItem = await response.Content.ReadAsAsync<T>();
                }
            }
        }
    }
}