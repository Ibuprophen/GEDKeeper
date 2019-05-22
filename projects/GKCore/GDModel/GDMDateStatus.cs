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

using GDModel.Providers.GEDCOM;

namespace GDModel
{
    public sealed class GDMDateStatus : GDMTag
    {
        public GDMDate ChangeDate
        {
            get { return GetTag<GDMDate>(GEDCOMTagType.DATE, GDMDate.Create); }
        }


        public new static GDMTag Create(GDMObject owner, string tagName, string tagValue)
        {
            return new GDMDateStatus(owner, tagName, tagValue);
        }

        public GDMDateStatus(GDMObject owner) : base(owner)
        {
            SetName(GEDCOMTagType.STAT);
        }

        public GDMDateStatus(GDMObject owner, string tagName, string tagValue) : this(owner)
        {
            SetNameValue(tagName, tagValue);
        }
    }
}
