﻿/*
 *  "GEDKeeper", the personal genealogical database editor.
 *  Copyright (C) 2009-2017 by Sergey V. Zhdanovskih.
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

using ArborGVT;
using Eto.Drawing;
using Eto.Forms;
using GKCommon.GEDCOM;
using GKCommon.SmartGraph;
using GKCore;
using GKCore.Interfaces;
using GKCore.Types;
using GKUI.Components;

namespace GKUI
{
    public partial class PatriarchsViewerWin : Form
    {
        private readonly IBaseWindow fBase;
        private bool fTipShow;

        public PatriarchsViewerWin(IBaseWindow baseWin, int minGens)
        {
            InitializeComponent();

            fBase = baseWin;
            fTipShow = false;

            using (Graph graph = PatriarchsMan.GetPatriarchsGraph(fBase.Context, minGens, false, true)) {
                PL_ConvertGraphToArborSystem(graph, arborViewer1.Sys);
            }

            arborViewer1.NodesDragging = true;
            arborViewer1.start();
        }

        private void ArborViewer1_MouseMove(object sender, MouseEventArgs e)
        {
            Point mpt = new Point(e.Location);
            ArborNode resNode = arborViewer1.getNodeByCoord(mpt.X, mpt.Y);

            if (resNode == null) {
                if (fTipShow) {
                    //fTip.Hide(arborViewer1);
                    arborViewer1.ToolTip = string.Empty;
                    fTipShow = false;
                }
            } else {
                if (!fTipShow) {
                    string xref = resNode.Sign;
                    //GEDCOMIndividualRecord iRec = fBase.Tree.XRefIndex_Find(xref) as GEDCOMIndividualRecord;
                    //string txt = iRec.GetNameString(true, false) + " [" + xref + "]";

                    GEDCOMFamilyRecord famRec = fBase.Context.Tree.XRefIndex_Find(xref) as GEDCOMFamilyRecord;
                    string txt = GKUtils.GetFamilyString(famRec) + " [" + xref + "] "/* + resNode.Mass.ToString()*/;

                    //fTip.Show(txt, arborViewer1, mpt.X + 24, mpt.Y);
                    arborViewer1.ToolTip = txt;
                    fTipShow = true;
                }
            }
        }

        private static void PL_ConvertGraphToArborSystem(IGraph graph, ArborSystem sys)
        {
            foreach (Vertex vtx in graph.Vertices) {
                var arbNode = sys.addNode(vtx.Sign) as ArborNodeEx;
                PGNode pgNode = (PGNode)vtx.Value;

                arbNode.Color = (pgNode.Type == PGNodeType.Intersection) ? Colors.BlueViolet : Colors.Navy;
                arbNode.Mass = pgNode.Size;
            }

            foreach (Edge edge in graph.Edges) {
                sys.addEdge(edge.Source.Sign, edge.Target.Sign);
            }
        }
    }
}