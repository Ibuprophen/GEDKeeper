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

using BSLib;
using GDModel.Providers.GEDCOM;

namespace GDModel
{
    public class GDMIndividualAttribute : GDMCustomEvent
    {
        // TODO: eliminate this functionality
        public StringList PhysicalDescription
        {
            get { return GEDCOMUtils.GetTagStrings(this); }
            set { GEDCOMUtils.SetTagStrings(this, value); }
        }


        public GDMIndividualAttribute(GDMObject owner) : base(owner)
        {
        }

        public GDMIndividualAttribute(GDMObject owner, int tagId, string tagValue) : this(owner)
        {
            SetNameValue(tagId, tagValue);
        }

        public new static GDMTag Create(GDMObject owner, int tagId, string tagValue)
        {
            return new GDMIndividualAttribute(owner, tagId, tagValue);
        }
    }
}
