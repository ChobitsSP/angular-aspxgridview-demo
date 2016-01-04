using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace WebApplication1
{
    public class FileLogger
    {
        const string LOG_FILE_NAME = "service.log";
        const string DATETIME_FORMAT = "yyyy-MM-dd HH:mm:ss";
        static readonly string SERVICE_PATH = GetServiceDirectory();

        public static readonly FileLogger logger = new FileLogger();

        static FileLogger()
        {
            try
            {
                string file_path = Path.Combine(System.Web.HttpContext.Current.Request.PhysicalApplicationPath, LOG_FILE_NAME);
                Trace.Listeners.Add(new TextWriterTraceListener(file_path));
            }
            catch //(Exception e)  
            {
                Trace.Listeners.Add(new TextWriterTraceListener(Console.Out));
            }
            Trace.AutoFlush = true;
        }

        #region interface  

        public void Error(Exception exception)
        {
            Trace.WriteLine(FlattenException(exception), DateTime.Now.ToString(DATETIME_FORMAT) + " ERROR");
        }

        public void Error(string message)
        {
            Trace.WriteLine(message, DateTime.Now.ToString(DATETIME_FORMAT) + " ERROR");
        }

        public void Warn(string message)
        {
            Trace.WriteLine(message, DateTime.Now.ToString(DATETIME_FORMAT) + " WARN");
        }

        public void Info(string message)
        {
            Trace.WriteLine(message, DateTime.Now.ToString(DATETIME_FORMAT) + " INFO");
        }

        #endregion

        public static string GetServiceDirectory()
        {
            return Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
        }

        public static string FlattenException(Exception exception)
        {
            var stringBuilder = new StringBuilder();

            while (exception != null)
            {
                stringBuilder.AppendLine(exception.Message);
                stringBuilder.AppendLine(exception.StackTrace);

                exception = exception.InnerException;
            }

            return stringBuilder.ToString();
        }
    }
}
