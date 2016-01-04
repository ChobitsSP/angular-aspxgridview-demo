using DevExpress.Web;
using DevExpress.Web.Data;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Web.UI;

namespace WebApplication1
{
    public static class DevExtensions
    {
        public static void ASPxGridViewInit(this ASPxGridView grid)
        {
            grid.SettingsLoadingPanel.Text = "加载中";
            grid.SettingsBehavior.ConfirmDelete = true;

            foreach (var col in grid.Columns)
            {
                if (col.GetType() == typeof(GridViewDataDateColumn))
                {
                    GridViewDataDateColumn cus_col = col as GridViewDataDateColumn;
                    cus_col.PropertiesDateEdit.CalendarProperties.ClearButtonText = "取消";
                    cus_col.PropertiesDateEdit.CalendarProperties.TodayButtonText = "今天";
                }
            }
        }

        public static T FindEditRowCellTemplateControl<T>(this ASPxGridView grid, string columnName, string id) where T : Control
        {
            Control control = grid.FindEditRowCellTemplateControl((GridViewDataColumn)grid.Columns[columnName], id);
            return control as T;
        }

        public static List<Control> GetAllControls(this Control grid)
        {
            var list = new List<Control>();
            foreach (Control c in grid.Controls)
            {
                GetControlList(list, c);
            }
            return list;
        }

        public static T FindFirstControl<T>(this ASPxGridView grid, Func<Control, bool> func) where T : Control
        {
            return grid.GetAllControls().FirstOrDefault(t => func(t)) as T;
        }

        public static bool FindCheckBoxValue(this ASPxGridView grid, string columnName, string id)
        {
            var ASPxCheckBox = grid.FindEditRowCellTemplateControl<ASPxCheckBox>(columnName, id);
            return ASPxCheckBox != null ? ASPxCheckBox.Checked : false;
        }

        static void GetControlList(List<Control> list, Control control)
        {
            foreach (Control c in control.Controls)
            {
                list.Add(c);
                if (c.HasControls())
                {
                    GetControlList(list, c);
                }
            }
        }

        public static string GetEditText(this ASPxGridView grid, string columnName, string id)
        {
            return grid.FindEditRowCellTemplateControl<ASPxTextBox>(columnName, id).Text;
        }

        public static void SetCheckBoxValue(this ASPxGridView grid, OrderedDictionary NewValues, string id, params string[] columnNames)
        {
            foreach (var col in columnNames)
            {
                NewValues[col] = grid.FindCheckBoxValue(col, id) ? 1 : 0;
            }
        }

        public static void SetTextBoxValue(this ASPxGridView grid, string columnName, string id, string value)
        {

            var box =
            grid.FindEditRowCellTemplateControl<ASPxTextBox>(columnName, id);


            grid.FindEditRowCellTemplateControl<ASPxTextBox>(columnName, id).Value = value;
        }

        public static bool IsErrDateRange(this ASPxGridView grid, ASPxDataValidationEventArgs e, string start_name, string end_name)
        {
            DateTime? start_date = (DateTime?)e.NewValues[start_name];
            DateTime? end_date = (DateTime?)e.NewValues[end_name];

            if (start_date.HasValue && end_date.HasValue && start_date > end_date)
            {
                e.Errors.Add(grid.Columns[start_name], "请选择正确的时间范围");
                e.Errors.Add(grid.Columns[end_name], "请选择正确的时间范围");
                e.RowError = "请选择正确的时间范围";
                //throw new Exception("事件名称不可为空");
                return true;
            }

            return false;
        }
    }
}
