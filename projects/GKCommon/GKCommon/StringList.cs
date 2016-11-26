﻿/*
 *  "GEDKeeper", the personal genealogical database editor.
 *  Copyright (C) 2009-2016 by Serg V. Zhdanovskih (aka Alchemist, aka Norseman).
 *
 *  This file is part of "GEDKeeper".
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using System;
using System.Collections.Generic;
using System.Text;

namespace GKCommon
{
    [Serializable]
    public class StringListException : Exception
    {
        public StringListException(string message) : base(message)
        {
        }
    }

    /*
     * I.e. EventHandler
     */
    public delegate void NotifyEventHandler(object sender /*, EventArgs e*/);

    public enum DuplicateSolve
    {
        Ignore,
        Accept,
        Error
    }

    /// <summary>
    /// 
    /// </summary>
    public sealed class StringList : BaseObject
    {
        private sealed class StringItem
        {
            public string StrVal;
            public object ObjVal;

            public StringItem(string str, object obj)
            {
                this.StrVal = str;
                this.ObjVal = obj;
            }
        }

        private readonly List<StringItem> fList;
        private bool fCaseSensitive;
        private DuplicateSolve fDuplicateSolve;
        private NotifyEventHandler fOnChange;
        private NotifyEventHandler fOnChanging;
        private bool fSorted;
        private int fUpdateCount;

        private const string LINE_BREAK = "\r\n";

        public bool CaseSensitive
        {
            get {
                return this.fCaseSensitive;
            }
            set {
                if (value != this.fCaseSensitive) {
                    this.fCaseSensitive = value;
                    if (this.fSorted) this.Sort();
                }
            }
        }

        public int Count
        {
            get { return this.fList.Count; }
        }

        public string this[int index]
        {
            get {
                if (index < 0 || index >= this.fList.Count)
                    throw new StringListException(string.Format("List index out of bounds ({0})", index));

                return this.fList[index].StrVal;
            }

            set {
                if (this.Sorted)
                    throw new StringListException("Operation not allowed on sorted list");

                if (index < 0 || index >= this.fList.Count)
                    throw new StringListException(string.Format("List index out of bounds ({0})", index));

                this.Changing();
                this.fList[index].StrVal = value;
                this.Changed();
            }
        }

        public DuplicateSolve DuplicateSolve
        {
            get { return this.fDuplicateSolve; }
            set { this.fDuplicateSolve = value; }
        }

        public event NotifyEventHandler OnChange
        {
            add { this.fOnChange = value; }
            remove { if (this.fOnChange == value) this.fOnChange = null; }
        }

        public event NotifyEventHandler OnChanging
        {
            add { this.fOnChanging = value; }
            remove { if (this.fOnChanging == value) this.fOnChanging = null; }
        }

        public bool Sorted
        {
            get {
                return this.fSorted;
            }
            set {
                if (this.fSorted != value) {
                    if (value) this.Sort();
                    this.fSorted = value;
                }
            }
        }

        public string Text
        {
            get { return this.GetTextStr(); }
            set { this.SetTextStr(value); }
        }


        public StringList()
        {
            this.fList = new List<StringItem>();
        }

        public StringList(string str) : this()
        {
            this.SetTextStr(str);
        }

        public StringList(string[] list) : this()
        {
            if (list == null)
                throw new ArgumentNullException("list");

            for (int i = 0; i < list.Length; i++)
            {
                this.AddObject(list[i], null);
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                //this.fList = null;
                /*int num = this.fList.Count;
                for (int i = 0; i < num; i++)
                {
                    IDisposable inst = this.fList[i].FObject as IDisposable;
                    if (inst != null) inst.Dispose();
                }*/
            }
            base.Dispose(disposing);
        }

        public bool IsEmpty()
        {
            return (this.fList.Count <= 0);
        }

        public object GetObject(int index)
        {
            if (index < 0 || index >= this.fList.Count)
                throw new StringListException(string.Format("List index out of bounds ({0})", index));

            return this.fList[index].ObjVal;
        }

        public void SetObject(int index, object obj)
        {
            if (index < 0 || index >= this.fList.Count)
                throw new StringListException(string.Format("List index out of bounds ({0})", index));

            this.Changing();
            this.fList[index].ObjVal = obj;
            this.Changed();
        }

        private string GetTextStr()
        {
            StringBuilder buffer = new StringBuilder();

            int num = this.fList.Count;
            for (int i = 0; i < num; i++)
            {
                buffer.Append(this[i]);
                buffer.Append(LINE_BREAK);
            }

            return buffer.ToString();
        }

        private void SetTextStr(string value)
        {
            this.BeginUpdate();
            try
            {
                this.Clear();

                int start = 0;
                int lbLen = LINE_BREAK.Length;
                int pos = value.IndexOf(LINE_BREAK);
                
                while (pos >= 0)
                {
                    string s = value.Substring(start, pos - start);
                    this.Add(s);
                    start = pos + lbLen;
                    pos = value.IndexOf(LINE_BREAK, start);
                }

                if (start <= value.Length)
                {
                    string s = value.Substring(start, (value.Length - start));
                    this.Add(s);
                }
            }
            finally
            {
                this.EndUpdate();
            }
        }

        public int Add(string str)
        {
            return this.AddObject(str, null);
        }

        public int AddObject(string str, object obj)
        {
            int result;

            if (!this.fSorted) {
                result = this.fList.Count;
            } else {
                if (this.Find(str, out result)) {
                    if (this.fDuplicateSolve == DuplicateSolve.Ignore)
                        return result;

                    if (this.fDuplicateSolve == DuplicateSolve.Error)
                        throw new StringListException("String list does not allow duplicates");
                }
            }

            this.InsertItem(result, str, obj);

            return result;
        }

        public void AddStrings(StringList strList)
        {
            if (strList == null) return;

            this.BeginUpdate();
            try
            {
                int num = strList.Count;
                for (int i = 0; i < num; i++) {
                    this.AddObject(strList[i], strList.GetObject(i));
                }
            }
            finally
            {
                this.EndUpdate();
            }
        }

        public void Assign(StringList source)
        {
            if (source == null) return;

            this.BeginUpdate();
            try
            {
                this.Clear();
                this.AddStrings(source);
            }
            finally
            {
                this.EndUpdate();
            }
        }

        public void Clear()
        {
            if (this.fList.Count == 0) return;

            this.Changing();
            this.fList.Clear();
            this.Changed();
        }

        public void Delete(int index)
        {
            if (index < 0 || index >= this.fList.Count)
                throw new StringListException(string.Format("List index out of bounds ({0})", index));

            this.Changing();
            if (index < this.fList.Count)
            {
                this.fList.RemoveAt(index);
            }
            this.Changed();
        }

        public void Exchange(int index1, int index2)
        {
            if (index1 < 0 || index1 >= this.fList.Count)
                throw new StringListException(string.Format("List index out of bounds ({0})", index1));

            if (index2 < 0 || index2 >= this.fList.Count)
                throw new StringListException(string.Format("List index out of bounds ({0})", index2));

            this.Changing();
            this.ExchangeItems(index1, index2);
            this.Changed();
        }

        public void Insert(int index, string str)
        {
            this.InsertObject(index, str, null);
        }

        public void InsertObject(int index, string str, object obj)
        {
            if (this.Sorted)
                throw new StringListException("Operation not allowed on sorted list");

            if (index < 0 || index > this.Count)
                throw new StringListException(string.Format("List index out of bounds ({0})", index));

            this.InsertItem(index, str, obj);
        }

        private void InsertItem(int index, string str, object obj)
        {
            this.Changing();
            this.fList.Insert(index, new StringItem(str, obj));
            this.Changed();
        }

        public void ExchangeItems(int index1, int index2)
        {
            StringItem temp = this.fList[index1];
            this.fList[index1] = this.fList[index2];
            this.fList[index2] = temp;
        }

        public string[] ToArray()
        {
            int len = this.Count;
            string[] result = new string[len];
            for (int i = 0; i < len; i++) {
                result[i] = this[i];
            }
            return result;
        }

        #region Updating

        private void SetUpdateState(bool updating)
        {
            if (updating) {
                this.Changing();
            } else {
                this.Changed();
            }
        }

        public void BeginUpdate()
        {
            if (this.fUpdateCount == 0) {
                this.SetUpdateState(true);
            }
            this.fUpdateCount++;
        }

        public void EndUpdate()
        {
            this.fUpdateCount--;
            if (this.fUpdateCount == 0) {
                this.SetUpdateState(false);
            }
        }

        private void Changed()
        {
            if (this.fUpdateCount == 0 && this.fOnChange != null) {
                this.fOnChange(this);
            }
        }

        private void Changing()
        {
            if (this.fUpdateCount == 0 && this.fOnChanging != null) {
                this.fOnChanging(this);
            }
        }

        #endregion

        #region Search

        public int IndexOfObject(object obj)
        {
            int num = this.fList.Count;
            for (int i = 0; i < num; i++) {
                if (this.fList[i].ObjVal == obj) {
                    return i;
                }
            }

            return -1;
        }

        public int IndexOf(string str)
        {
            int result = -1;
            if (this.fList.Count <= 0) return result;

            if (!this.fSorted) {
                int num = this.fList.Count;
                for (int i = 0; i < num; i++) {
                    if (this.CompareStrings(this.fList[i].StrVal, str) == 0) {
                        result = i;
                        break;
                    }
                }
            } else {
                if (!this.Find(str, out result)) {
                    result = -1;
                }
            }

            return result;
        }

        /// <summary>
        /// Important: `index`, returned by this method, necessary in the
        /// methods of insertion for sorted lists - even when the search
        /// string is not found.
        /// </summary>
        /// <param name="str"></param>
        /// <param name="index"></param>
        /// <returns></returns>
        private bool Find(string str, out int index)
        {
            bool result = false;

            int low = 0;
            int high = this.fList.Count - 1;

            while (low <= high) {
                int idx = (int)((uint)(low + high) >> 1);
                int cmp = this.CompareStrings(this.fList[idx].StrVal, str);

                if (cmp < 0) {
                    low = idx + 1;
                } else {
                    high = idx - 1;

                    if (cmp == 0) {
                        result = true;

                        if (this.fDuplicateSolve != DuplicateSolve.Accept) {
                            low = idx;
                        }
                    }
                }
            }

            index = low;

            return result;
        }

        #endregion

        #region Sorting

        private int CompareStrings(string s1, string s2)
        {
            return string.Compare(s1, s2, !this.fCaseSensitive);
        }

        private int CompareItems(StringItem item1, StringItem item2)
        {
            return string.Compare(item1.StrVal, item2.StrVal, !this.fCaseSensitive);
        }

        public void Sort()
        {
            if (!this.fSorted && this.fList.Count > 1)
            {
                this.Changing();
                SysUtils.QuickSort(fList, CompareItems);
                this.Changed();
            }
        }

        #endregion
    }
}
