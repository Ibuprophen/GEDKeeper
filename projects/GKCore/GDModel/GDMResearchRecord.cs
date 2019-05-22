﻿/*
 *  "GEDKeeper", the personal genealogical database editor.
 *  Copyright (C) 2009-2019 by Sergey V. Zhdanovskih.
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

using System.IO;

namespace GKCommon.GEDCOM
{
    /// <summary>
    /// This type of Genealogical Data Model (GDM) defines the priority of the research.
    /// </summary>
    public enum GDMResearchPriority
    {
        rpNone,
        rpLow,
        rpNormal,
        rpHigh,
        rpTop
    }


    /// <summary>
    /// This type of Genealogical Data Model (GDM) defines the status of the research.
    /// </summary>
    public enum GDMResearchStatus
    {
        rsDefined,
        rsInProgress,
        rsOnHold,
        rsProblems,
        rsCompleted,
        rsWithdrawn
    }


    public sealed class GDMResearchRecord : GDMRecord
    {
        private GDMList<GDMPointer> fTasks;
        private GDMList<GDMPointer> fCommunications;
        private GDMList<GDMPointer> fGroups;


        public string ResearchName
        {
            get { return GetTagStringValue(GEDCOMTagType.NAME); }
            set { SetTagStringValue(GEDCOMTagType.NAME, value); }
        }

        public GDMResearchPriority Priority
        {
            get { return GEDCOMUtils.GetPriorityVal(GetTagStringValue(GEDCOMTagType._PRIORITY)); }
            set { SetTagStringValue(GEDCOMTagType._PRIORITY, GEDCOMUtils.GetPriorityStr(value)); }
        }

        public GDMResearchStatus Status
        {
            get { return GEDCOMUtils.GetStatusVal(GetTagStringValue(GEDCOMTagType._STATUS)); }
            set { SetTagStringValue(GEDCOMTagType._STATUS, GEDCOMUtils.GetStatusStr(value)); }
        }

        public GDMDate StartDate
        {
            get { return GetTag<GDMDate>(GEDCOMTagType._STARTDATE, GDMDate.Create); }
        }

        public GDMDate StopDate
        {
            get { return GetTag<GDMDate>(GEDCOMTagType._STOPDATE, GDMDate.Create); }
        }

        public int Percent
        {
            get { return GetTagIntegerValue(GEDCOMTagType._PERCENT, 0); }
            set { SetTagIntegerValue(GEDCOMTagType._PERCENT, value); }
        }

        public GDMList<GDMPointer> Tasks
        {
            get { return fTasks; }
        }

        public GDMList<GDMPointer> Communications
        {
            get { return fCommunications; }
        }

        public GDMList<GDMPointer> Groups
        {
            get { return fGroups; }
        }


        public GDMResearchRecord(GDMObject owner) : base(owner)
        {
            SetRecordType(GEDCOMRecordType.rtResearch);
            SetName(GEDCOMTagType._RESEARCH);

            fTasks = new GDMList<GDMPointer>(this);
            fCommunications = new GDMList<GDMPointer>(this);
            fGroups = new GDMList<GDMPointer>(this);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing) {
                fTasks.Dispose();
                fCommunications.Dispose();
                fGroups.Dispose();
            }
            base.Dispose(disposing);
        }

        public override void Clear()
        {
            base.Clear();

            fTasks.Clear();
            fCommunications.Clear();
            fGroups.Clear();
        }

        public override bool IsEmpty()
        {
            return base.IsEmpty() && fTasks.Count == 0 && fCommunications.Count == 0 && fGroups.Count == 0;
        }

        public override void ReplaceXRefs(XRefReplacer map)
        {
            base.ReplaceXRefs(map);

            fTasks.ReplaceXRefs(map);
            fCommunications.ReplaceXRefs(map);
            fGroups.ReplaceXRefs(map);
        }

        public override void SaveToStream(StreamWriter stream, int level)
        {
            base.SaveToStream(stream, level);

            level += 1;
            fTasks.SaveToStream(stream, level);
            fCommunications.SaveToStream(stream, level);
            fGroups.SaveToStream(stream, level);
        }

        public bool AddTask(GDMTaskRecord taskRecord)
        {
            bool result = false;

            if (taskRecord != null) {
                GDMPointer ptr = new GDMPointer(this);
                ptr.SetNameValue(GEDCOMTagType._TASK, taskRecord);
                fTasks.Add(ptr);
                result = true;
            }

            return result;
        }

        public void RemoveTask(GDMTaskRecord taskRecord)
        {
            if (taskRecord == null) return;

            fTasks.DeleteAt(IndexOfTask(taskRecord));
        }

        public int IndexOfTask(GDMTaskRecord taskRec)
        {
            int result = -1;

            if (taskRec != null) {
                int num = fTasks.Count;
                for (int i = 0; i < num; i++) {
                    if (fTasks[i].XRef == taskRec.XRef) {
                        result = i;
                        break;
                    }
                }
            }

            return result;
        }

        public bool AddGroup(GDMGroupRecord groupRecord)
        {
            bool result = false;

            if (groupRecord != null) {
                GDMPointer ptr = new GDMPointer(this);
                ptr.SetNameValue(GEDCOMTagType._GROUP, groupRecord);
                fGroups.Add(ptr);
                result = true;
            }

            return result;
        }

        public void RemoveGroup(GDMGroupRecord groupRecord)
        {
            if (groupRecord == null) return;

            fGroups.DeleteAt(IndexOfGroup(groupRecord));
        }

        public int IndexOfGroup(GDMGroupRecord groupRec)
        {
            int result = -1;

            if (groupRec != null) {
                int num = fGroups.Count;
                for (int i = 0; i < num; i++) {
                    if (fGroups[i].XRef == groupRec.XRef) {
                        result = i;
                        break;
                    }
                }
            }

            return result;
        }

        public bool AddCommunication(GDMCommunicationRecord commRecord)
        {
            bool result = false;

            if (commRecord != null) {
                GDMPointer ptr = new GDMPointer(this);
                ptr.SetNameValue(GEDCOMTagType._COMM, commRecord);
                fCommunications.Add(ptr);
                result = true;
            }

            return result;
        }

        public void RemoveCommunication(GDMCommunicationRecord commRecord)
        {
            if (commRecord == null) return;

            fCommunications.DeleteAt(IndexOfCommunication(commRecord));
        }

        public int IndexOfCommunication(GDMCommunicationRecord commRec)
        {
            int result = -1;

            if (commRec != null) {
                int num = fCommunications.Count;
                for (int i = 0; i < num; i++) {
                    if (fCommunications[i].XRef == commRec.XRef) {
                        result = i;
                        break;
                    }
                }
            }

            return result;
        }
    }
}