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

namespace GKCommon.GEDCOM
{
    public class GDMPointerWithNotes : GDMPointer
    {
        private GDMList<GDMNotes> fNotes;

        public GDMList<GDMNotes> Notes
        {
            get { return fNotes; }
        }


        public GDMPointerWithNotes(GDMObject owner) : base(owner)
        {
            fNotes = new GDMList<GDMNotes>(this);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing) {
                fNotes.Dispose();
            }
            base.Dispose(disposing);
        }

        public override void Clear()
        {
            base.Clear();
            fNotes.Clear();
        }

        public override bool IsEmpty()
        {
            return base.IsEmpty() && (fNotes.Count == 0);
        }

        public override void ReplaceXRefs(XRefReplacer map)
        {
            base.ReplaceXRefs(map);
            fNotes.ReplaceXRefs(map);
        }
    }
}