﻿using System;

namespace GKUI
{
	partial class TfmChart
	{
		private System.Windows.Forms.SaveFileDialog SaveDialog1;
		private System.Windows.Forms.ToolBar ToolBar1;
		private System.Windows.Forms.ToolBarButton tbImageSave;
		private System.Windows.Forms.ToolBarButton tbPrev;
		private System.Windows.Forms.ToolBarButton tbNext;
		private System.Windows.Forms.ContextMenu MenuPerson;
		private System.Windows.Forms.MenuItem miEdit;
		private System.Windows.Forms.MenuItem N1;
		private System.Windows.Forms.MenuItem miSpouseAdd;
		private System.Windows.Forms.MenuItem miSonAdd;
		private System.Windows.Forms.MenuItem miDaughterAdd;
		private System.Windows.Forms.MenuItem miFamilyAdd;
		private System.Windows.Forms.MenuItem N2;
		private System.Windows.Forms.MenuItem miDelete;
		private System.Windows.Forms.MenuItem N3;
		private System.Windows.Forms.MenuItem miRebuildKinships;
		private System.Windows.Forms.ToolBarButton tbFilter;
		private System.Windows.Forms.ToolBarButton tbModes;
		private System.Windows.Forms.ContextMenu MenuModes;
		private System.Windows.Forms.MenuItem miModeBoth;
		private System.Windows.Forms.MenuItem miModeAncestors;
		private System.Windows.Forms.MenuItem miModeDescendants;
		private System.Windows.Forms.MenuItem N7;
		private System.Windows.Forms.MenuItem miTraceRoot;
		private System.Windows.Forms.MenuItem miRebuildTree;
		private System.Windows.Forms.ToolBarButton tbScales;
		private System.Windows.Forms.ContextMenu MenuScales;
		private System.Windows.Forms.MenuItem N501;
		private System.Windows.Forms.MenuItem N601;
		private System.Windows.Forms.MenuItem N701;
		private System.Windows.Forms.MenuItem N801;
		private System.Windows.Forms.MenuItem N901;
		private System.Windows.Forms.MenuItem N1001;
		private System.Windows.Forms.ToolBarButton tbGens;
		private System.Windows.Forms.ContextMenu MenuGens;
		private System.Windows.Forms.MenuItem miGensInf;
		private System.Windows.Forms.MenuItem miGens1;
		private System.Windows.Forms.MenuItem miGens2;
		private System.Windows.Forms.MenuItem miGens3;
		private System.Windows.Forms.MenuItem miGens4;
		private System.Windows.Forms.MenuItem miGens5;
		private System.Windows.Forms.MenuItem miGens6;
		private System.Windows.Forms.MenuItem miGens7;
		private System.Windows.Forms.MenuItem miGens8;
		private System.Windows.Forms.MenuItem miGens9;
		private System.Windows.Forms.MenuItem N8;
		private System.Windows.Forms.MenuItem miFillColor;
		private System.Windows.Forms.MenuItem miFillImage;

		private void InitializeComponent()
		{
			this.SaveDialog1 = new System.Windows.Forms.SaveFileDialog();
			this.ToolBar1 = new System.Windows.Forms.ToolBar();
			this.tbImageSave = new System.Windows.Forms.ToolBarButton();
			this.tbs1 = new System.Windows.Forms.ToolBarButton();
			this.tbGens = new System.Windows.Forms.ToolBarButton();
			this.MenuGens = new System.Windows.Forms.ContextMenu();
			this.miGensInf = new System.Windows.Forms.MenuItem();
			this.miGens1 = new System.Windows.Forms.MenuItem();
			this.miGens2 = new System.Windows.Forms.MenuItem();
			this.miGens3 = new System.Windows.Forms.MenuItem();
			this.miGens4 = new System.Windows.Forms.MenuItem();
			this.miGens5 = new System.Windows.Forms.MenuItem();
			this.miGens6 = new System.Windows.Forms.MenuItem();
			this.miGens7 = new System.Windows.Forms.MenuItem();
			this.miGens8 = new System.Windows.Forms.MenuItem();
			this.miGens9 = new System.Windows.Forms.MenuItem();
			this.tbs2 = new System.Windows.Forms.ToolBarButton();
			this.tbPrev = new System.Windows.Forms.ToolBarButton();
			this.tbNext = new System.Windows.Forms.ToolBarButton();
			this.tbs3 = new System.Windows.Forms.ToolBarButton();
			this.tbScales = new System.Windows.Forms.ToolBarButton();
			this.MenuScales = new System.Windows.Forms.ContextMenu();
			this.N501 = new System.Windows.Forms.MenuItem();
			this.N601 = new System.Windows.Forms.MenuItem();
			this.N701 = new System.Windows.Forms.MenuItem();
			this.N801 = new System.Windows.Forms.MenuItem();
			this.N901 = new System.Windows.Forms.MenuItem();
			this.N1001 = new System.Windows.Forms.MenuItem();
			this.tbs4 = new System.Windows.Forms.ToolBarButton();
			this.tbFilter = new System.Windows.Forms.ToolBarButton();
			this.tbs5 = new System.Windows.Forms.ToolBarButton();
			this.tbModes = new System.Windows.Forms.ToolBarButton();
			this.MenuModes = new System.Windows.Forms.ContextMenu();
			this.miModeBoth = new System.Windows.Forms.MenuItem();
			this.miModeAncestors = new System.Windows.Forms.MenuItem();
			this.miModeDescendants = new System.Windows.Forms.MenuItem();
			this.N7 = new System.Windows.Forms.MenuItem();
			this.miTraceRoot = new System.Windows.Forms.MenuItem();
			this.N8 = new System.Windows.Forms.MenuItem();
			this.miFillColor = new System.Windows.Forms.MenuItem();
			this.miFillImage = new System.Windows.Forms.MenuItem();
			this.MenuPerson = new System.Windows.Forms.ContextMenu();
			this.miEdit = new System.Windows.Forms.MenuItem();
			this.N1 = new System.Windows.Forms.MenuItem();
			this.miFamilyAdd = new System.Windows.Forms.MenuItem();
			this.miSpouseAdd = new System.Windows.Forms.MenuItem();
			this.miSonAdd = new System.Windows.Forms.MenuItem();
			this.miDaughterAdd = new System.Windows.Forms.MenuItem();
			this.N2 = new System.Windows.Forms.MenuItem();
			this.miDelete = new System.Windows.Forms.MenuItem();
			this.N3 = new System.Windows.Forms.MenuItem();
			this.miRebuildTree = new System.Windows.Forms.MenuItem();
			this.miRebuildKinships = new System.Windows.Forms.MenuItem();
			this.colorDialog1 = new System.Windows.Forms.ColorDialog();
			this.OpenDialog1 = new System.Windows.Forms.OpenFileDialog();
			this.SuspendLayout();
			// 
			// SaveDialog1
			// 
			this.SaveDialog1.DefaultExt = "tga";
			this.SaveDialog1.Filter = "Файлы BMP (*.bmp)|*.bmp|Файлы JPEG (*.jpg)|*.jpg|Файлы EMF (*.emf)|*.emf";
			this.SaveDialog1.FilterIndex = 2;
			// 
			// ToolBar1
			// 
			this.ToolBar1.Appearance = System.Windows.Forms.ToolBarAppearance.Flat;
			this.ToolBar1.Buttons.AddRange(new System.Windows.Forms.ToolBarButton[] {
									this.tbImageSave,
									this.tbs1,
									this.tbGens,
									this.tbs2,
									this.tbPrev,
									this.tbNext,
									this.tbs3,
									this.tbScales,
									this.tbs4,
									this.tbFilter,
									this.tbs5,
									this.tbModes});
			this.ToolBar1.DropDownArrows = true;
			this.ToolBar1.Location = new System.Drawing.Point(0, 0);
			this.ToolBar1.Name = "ToolBar1";
			this.ToolBar1.ShowToolTips = true;
			this.ToolBar1.Size = new System.Drawing.Size(822, 28);
			this.ToolBar1.TabIndex = 0;
			this.ToolBar1.TextAlign = System.Windows.Forms.ToolBarTextAlign.Right;
			this.ToolBar1.ButtonClick += new System.Windows.Forms.ToolBarButtonClickEventHandler(this.ToolBar1_ButtonClick);
			// 
			// tbImageSave
			// 
			this.tbImageSave.ImageIndex = 6;
			this.tbImageSave.Name = "tbImageSave";
			this.tbImageSave.ToolTipText = "Сохранить изображение";
			// 
			// tbs1
			// 
			this.tbs1.ImageIndex = 7;
			this.tbs1.Name = "tbs1";
			this.tbs1.Style = System.Windows.Forms.ToolBarButtonStyle.Separator;
			// 
			// tbGens
			// 
			this.tbGens.DropDownMenu = this.MenuGens;
			this.tbGens.Name = "tbGens";
			this.tbGens.Style = System.Windows.Forms.ToolBarButtonStyle.DropDownButton;
			this.tbGens.Text = "Поколения";
			// 
			// MenuGens
			// 
			this.MenuGens.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
									this.miGensInf,
									this.miGens1,
									this.miGens2,
									this.miGens3,
									this.miGens4,
									this.miGens5,
									this.miGens6,
									this.miGens7,
									this.miGens8,
									this.miGens9});
			// 
			// miGensInf
			// 
			this.miGensInf.Checked = true;
			this.miGensInf.Index = 0;
			this.miGensInf.Text = "Inf";
			this.miGensInf.Click += new System.EventHandler(this.miGens9Click);
			// 
			// miGens1
			// 
			this.miGens1.Index = 1;
			this.miGens1.Text = "1";
			this.miGens1.Click += new System.EventHandler(this.miGens9Click);
			// 
			// miGens2
			// 
			this.miGens2.Index = 2;
			this.miGens2.Text = "2";
			this.miGens2.Click += new System.EventHandler(this.miGens9Click);
			// 
			// miGens3
			// 
			this.miGens3.Index = 3;
			this.miGens3.Text = "3";
			this.miGens3.Click += new System.EventHandler(this.miGens9Click);
			// 
			// miGens4
			// 
			this.miGens4.Index = 4;
			this.miGens4.Text = "4";
			this.miGens4.Click += new System.EventHandler(this.miGens9Click);
			// 
			// miGens5
			// 
			this.miGens5.Index = 5;
			this.miGens5.Text = "5";
			this.miGens5.Click += new System.EventHandler(this.miGens9Click);
			// 
			// miGens6
			// 
			this.miGens6.Index = 6;
			this.miGens6.Text = "6";
			this.miGens6.Click += new System.EventHandler(this.miGens9Click);
			// 
			// miGens7
			// 
			this.miGens7.Index = 7;
			this.miGens7.Text = "7";
			this.miGens7.Click += new System.EventHandler(this.miGens9Click);
			// 
			// miGens8
			// 
			this.miGens8.Index = 8;
			this.miGens8.Text = "8";
			this.miGens8.Click += new System.EventHandler(this.miGens9Click);
			// 
			// miGens9
			// 
			this.miGens9.Index = 9;
			this.miGens9.Text = "9";
			this.miGens9.Click += new System.EventHandler(this.miGens9Click);
			// 
			// tbs2
			// 
			this.tbs2.ImageIndex = 8;
			this.tbs2.Name = "tbs2";
			this.tbs2.Style = System.Windows.Forms.ToolBarButtonStyle.Separator;
			// 
			// tbPrev
			// 
			this.tbPrev.Enabled = false;
			this.tbPrev.ImageIndex = 22;
			this.tbPrev.Name = "tbPrev";
			// 
			// tbNext
			// 
			this.tbNext.Enabled = false;
			this.tbNext.ImageIndex = 23;
			this.tbNext.Name = "tbNext";
			// 
			// tbs3
			// 
			this.tbs3.ImageIndex = 24;
			this.tbs3.Name = "tbs3";
			this.tbs3.Style = System.Windows.Forms.ToolBarButtonStyle.Separator;
			// 
			// tbScales
			// 
			this.tbScales.DropDownMenu = this.MenuScales;
			this.tbScales.Name = "tbScales";
			this.tbScales.Style = System.Windows.Forms.ToolBarButtonStyle.DropDownButton;
			this.tbScales.Text = "Масштаб";
			// 
			// MenuScales
			// 
			this.MenuScales.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
									this.N501,
									this.N601,
									this.N701,
									this.N801,
									this.N901,
									this.N1001});
			// 
			// N501
			// 
			this.N501.Index = 0;
			this.N501.Text = "  50%";
			this.N501.Click += new System.EventHandler(this.N1001Click);
			// 
			// N601
			// 
			this.N601.Index = 1;
			this.N601.Text = "  60%";
			this.N601.Click += new System.EventHandler(this.N1001Click);
			// 
			// N701
			// 
			this.N701.Index = 2;
			this.N701.Text = "  70%";
			this.N701.Click += new System.EventHandler(this.N1001Click);
			// 
			// N801
			// 
			this.N801.Index = 3;
			this.N801.Text = "  80%";
			this.N801.Click += new System.EventHandler(this.N1001Click);
			// 
			// N901
			// 
			this.N901.Index = 4;
			this.N901.Text = "  90%";
			this.N901.Click += new System.EventHandler(this.N1001Click);
			// 
			// N1001
			// 
			this.N1001.Checked = true;
			this.N1001.Index = 5;
			this.N1001.Text = "100%";
			this.N1001.Click += new System.EventHandler(this.N1001Click);
			// 
			// tbs4
			// 
			this.tbs4.ImageIndex = 25;
			this.tbs4.Name = "tbs4";
			this.tbs4.Style = System.Windows.Forms.ToolBarButtonStyle.Separator;
			// 
			// tbFilter
			// 
			this.tbFilter.ImageIndex = 16;
			this.tbFilter.Name = "tbFilter";
			this.tbFilter.ToolTipText = "Фильтрация древа";
			// 
			// tbs5
			// 
			this.tbs5.ImageIndex = 17;
			this.tbs5.Name = "tbs5";
			this.tbs5.Style = System.Windows.Forms.ToolBarButtonStyle.Separator;
			// 
			// tbModes
			// 
			this.tbModes.DropDownMenu = this.MenuModes;
			this.tbModes.ImageIndex = 21;
			this.tbModes.Name = "tbModes";
			this.tbModes.Style = System.Windows.Forms.ToolBarButtonStyle.DropDownButton;
			this.tbModes.ToolTipText = "Режимы";
			// 
			// MenuModes
			// 
			this.MenuModes.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
									this.miModeBoth,
									this.miModeAncestors,
									this.miModeDescendants,
									this.N7,
									this.miTraceRoot,
									this.N8,
									this.miFillColor,
									this.miFillImage});
			// 
			// miModeBoth
			// 
			this.miModeBoth.Index = 0;
			this.miModeBoth.Text = "miModeBoth";
			this.miModeBoth.Click += new System.EventHandler(this.miModeDescendantsClick);
			// 
			// miModeAncestors
			// 
			this.miModeAncestors.Index = 1;
			this.miModeAncestors.Text = "miModeAncestors";
			this.miModeAncestors.Click += new System.EventHandler(this.miModeDescendantsClick);
			// 
			// miModeDescendants
			// 
			this.miModeDescendants.Index = 2;
			this.miModeDescendants.Text = "miModeDescendants";
			this.miModeDescendants.Click += new System.EventHandler(this.miModeDescendantsClick);
			// 
			// N7
			// 
			this.N7.Index = 3;
			this.N7.Text = "-";
			// 
			// miTraceRoot
			// 
			this.miTraceRoot.Index = 4;
			this.miTraceRoot.Text = "miTraceRoot";
			this.miTraceRoot.Click += new System.EventHandler(this.miTraceRootClick);
			// 
			// N8
			// 
			this.N8.Index = 5;
			this.N8.Text = "-";
			// 
			// miFillColor
			// 
			this.miFillColor.Index = 6;
			this.miFillColor.Text = "miFillColor";
			this.miFillColor.Click += new System.EventHandler(this.miFillColorClick);
			// 
			// miFillImage
			// 
			this.miFillImage.Index = 7;
			this.miFillImage.Text = "miFillImage";
			this.miFillImage.Click += new System.EventHandler(this.miFillImageClick);
			// 
			// MenuPerson
			// 
			this.MenuPerson.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
									this.miEdit,
									this.N1,
									this.miFamilyAdd,
									this.miSpouseAdd,
									this.miSonAdd,
									this.miDaughterAdd,
									this.N2,
									this.miDelete,
									this.N3,
									this.miRebuildTree,
									this.miRebuildKinships});
			// 
			// miEdit
			// 
			this.miEdit.Index = 0;
			this.miEdit.Text = "miEdit";
			this.miEdit.Click += new System.EventHandler(this.miEditClick);
			// 
			// N1
			// 
			this.N1.Index = 1;
			this.N1.Text = "-";
			// 
			// miFamilyAdd
			// 
			this.miFamilyAdd.Index = 2;
			this.miFamilyAdd.Text = "miFamilyAdd";
			this.miFamilyAdd.Click += new System.EventHandler(this.miFamilyAddClick);
			// 
			// miSpouseAdd
			// 
			this.miSpouseAdd.Index = 3;
			this.miSpouseAdd.Text = "miSpouseAdd";
			this.miSpouseAdd.Click += new System.EventHandler(this.miSpouseAddClick);
			// 
			// miSonAdd
			// 
			this.miSonAdd.Index = 4;
			this.miSonAdd.Text = "miSonAdd";
			this.miSonAdd.Click += new System.EventHandler(this.miSonAddClick);
			// 
			// miDaughterAdd
			// 
			this.miDaughterAdd.Index = 5;
			this.miDaughterAdd.Text = "miDaughterAdd";
			this.miDaughterAdd.Click += new System.EventHandler(this.miDaughterAddClick);
			// 
			// N2
			// 
			this.N2.Index = 6;
			this.N2.Text = "-";
			// 
			// miDelete
			// 
			this.miDelete.Index = 7;
			this.miDelete.Text = "miDelete";
			this.miDelete.Click += new System.EventHandler(this.miDeleteClick);
			// 
			// N3
			// 
			this.N3.Index = 8;
			this.N3.Text = "-";
			// 
			// miRebuildTree
			// 
			this.miRebuildTree.Index = 9;
			this.miRebuildTree.Text = "miRebuildTree";
			this.miRebuildTree.Click += new System.EventHandler(this.miRebuildTreeClick);
			// 
			// miRebuildKinships
			// 
			this.miRebuildKinships.Index = 10;
			this.miRebuildKinships.Text = "miRebuildKinships";
			this.miRebuildKinships.Click += new System.EventHandler(this.miRebuildKinshipsClick);
			// 
			// OpenDialog1
			// 
			this.OpenDialog1.Filter = "Image Files|*.bmp;*.gif;*.png;*.jpg";
			// 
			// TfmChart
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 14);
			this.ClientSize = new System.Drawing.Size(822, 453);
			this.Controls.Add(this.ToolBar1);
			this.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
			this.KeyPreview = true;
			this.Name = "TfmChart";
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "Диаграмма";
			this.KeyDown += new System.Windows.Forms.KeyEventHandler(this.TfmChart_KeyDown);
			this.ResumeLayout(false);
			this.PerformLayout();
		}
		private System.Windows.Forms.OpenFileDialog OpenDialog1;
		private System.Windows.Forms.ColorDialog colorDialog1;
		private System.Windows.Forms.ToolBarButton tbs5;
		private System.Windows.Forms.ToolBarButton tbs4;
		private System.Windows.Forms.ToolBarButton tbs3;
		private System.Windows.Forms.ToolBarButton tbs2;
		private System.Windows.Forms.ToolBarButton tbs1;
	}
}