########### install files ###############
install(FILES
    ACEScg-elle-V4-g10.icc
    ClayRGB-elle-V4-srgbtrc.icc
    ClayRGB-elle-V2-g22.icc # for AdobeRGB
    WideRGB-elle-V2-g22.icc # for WideGamutRGB
    LargeRGB-elle-V2-g22.icc # for ProPhotoRGB

    Gray-D50-elle-V2-g10.icc
    Gray-D50-elle-V2-g18.icc
    Gray-D50-elle-V2-g22.icc
    Gray-D50-elle-V2-srgbtrc.icc
    Gray-D50-elle-V4-g10.icc
    Gray-D50-elle-V4-g18.icc
    Gray-D50-elle-V4-g22.icc
    Gray-D50-elle-V4-srgbtrc.icc
    Gray-D50-elle-V2-labl.icc
    Gray-D50-elle-V4-labl.icc
    Gray-D50-elle-V2-rec709.icc
    Gray-D50-elle-V4-rec709.icc

    sRGB-elle-V2-g10.icc
    sRGB-elle-V2-srgbtrc.icc

    Rec2020-elle-V4-g10.icc

    Lab-D50-Identity-elle-V2.icc
    Lab-D50-Identity-elle-V4.icc
    XYZ-D50-Identity-elle-V4.icc
DESTINATION ${KDE_INSTALL_DATADIR}/color/icc/krita)
