/*
 *  SPDX-FileCopyrightText: 2025 Wolthera van Hövell tot Westerflier <griffinvalley@gmail.com>
 *
 *  SPDX-License-Identifier: GPL-2.0-or-later
 */
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import org.krita.flake.text 1.0

TextPropertyBase {
    id: root;
    propertyName: i18nc("@label", "OpenType features");
    propertyType: TextPropertyBase.Character;
    toolTip: i18nc("@info:tooltip",
                   "Configure Open Type features.");
    searchTerms: i18nc("comma separated search terms for the font-feature-settings property, matching is case-insensitive",
                       "font-feature-settings, OpenType");

    OpenTypeFeatureModel {
        id: fontFeatureModel;
        onOpenTypeFeaturesChanged: {
            if (!blockSignals) {
                properties.fontFeatureSettings = openTypeFeatures;
            }
        }
    }

    onPropertiesUpdated: {
        blockSignals = true;
        // Setting text properties model will also set the opentype features.
        fontFeatureModel.setFromTextPropertiesModel(properties);
        visible = properties.fontFeatureSettingsState !== KoSvgTextPropertiesModel.PropertyUnset;
        blockSignals = false;
    }

    onEnableProperty: properties.fontFeatureSettingsState = KoSvgTextPropertiesModel.PropertySet;
    GridLayout {
        columns: 2;
        columnSpacing: columnSpacing;
        rowSpacing: columnSpacing;
        width: parent.width;

        RevertPropertyButton {
            revertState: properties.fontFeatureSettingsState;
            onClicked: properties.fontFeatureSettingsState = KoSvgTextPropertiesModel.PropertyUnset;
        }

        Label {
            text: propertyName;
            Layout.fillWidth: true;
        }

        Item {
            width: firstColumnWidth;
            height: 1;
        }

        ListView {
            id: featureView;
            Layout.fillWidth: true;
            Layout.preferredHeight: contentHeight;
            Layout.minimumHeight: noContentLabel.contentHeight;
            spacing: columnSpacing;

            Label {
                id: noContentLabel;
                text: i18n("No OpenType features are currently set.");
                wrapMode: Text.WordWrap;
                anchors.fill: parent;
                anchors.horizontalCenter: parent.horizontalCenter;
                visible: parent.count === 0;
                padding: columnSpacing
            }

            model: fontFeatureModel;
            delegate: RowLayout {
                id: activeFeatureDelegate;
                required property var model;
                required property int index;
                property string display: model.display;
                property string toolTip: model.toolTip;
                property string sample: model.sample;
                property string tag: model.tag;
                property var parameters: model.parameters;
                width: featureView.width;

                ComboBox {
                    id: activeFeatureControl;
                    Layout.fillWidth: true;
                    model: activeFeatureDelegate.parameters;
                    valueRole: "value";
                    textRole: "display";

                    currentIndex: activeFeatureDelegate.model.edit;

                    contentItem: OpenTypeFeatureDelegate {
                        display: activeFeatureControl.currentText;
                        toolTip: activeFeatureDelegate.toolTip;
                        sample: activeFeatureDelegate.sample;
                        tag: activeFeatureDelegate.tag;
                        enableMouseEvents: false;
                    }

                    ToolTip.text: activeFeatureDelegate.toolTip;
                    ToolTip.visible: activeFeatureControl.hovered;
                    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval;

                    delegate: OpenTypeFeatureDelegate {
                        display: modelData.display;
                        width: activeFeatureControl.width;
                        toolTip: display;
                        sample: activeFeatureDelegate.sample;
                        tag: activeFeatureDelegate.tag;
                        onFeatureClicked: {
                            activeFeatureControl.currentIndex = index;
                            activeFeatureControl.popup.close();
                        }
                    }

                    onCurrentValueChanged: {
                        activeFeatureDelegate.model.edit = currentValue;
                    }
                }


                ToolButton {
                    id: removeFeature;
                    icon.width: 22;
                    icon.height: 22;
                    icon.source: "qrc:///22_light_list-remove.svg"
                    onClicked: fontFeatureModel.removeFeature(parent.tag);
                    ToolTip.text: i18n("Remove feature.");
                    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval;
                    ToolTip.visible: hovered;
                }
            }
        }

        Item {
            width: firstColumnWidth;
            height: 1;
        }
        ComboBox {
            id: cmbAvailableFeatures;
            model: fontFeatureModel.featureFilterModel();
            textRole: "display";
            valueRole: "tag";
            Layout.fillWidth: true;

            editable: true;
            selectTextByMouse: true;

            onAccepted: {
                fontFeatureModel.addFeature(currentValue);
            }


            delegate: OpenTypeFeatureDelegate {
                required property var model;
                required property int index;
                display: model.display;
                toolTip: model.toolTip;
                sample: model.sample;
                tag: model.tag;
                width: cmbAvailableFeatures.width;
                visible: model.available;
                onFeatureClicked: (mouse) => {
                    cmbAvailableFeatures.currentIndex = index;
                    fontFeatureModel.addFeature(tag);
                    cmbAvailableFeatures.popup.close();
                }
            }
        }
    }
}

