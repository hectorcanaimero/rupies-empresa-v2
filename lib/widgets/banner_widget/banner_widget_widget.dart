import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'banner_widget_model.dart';
export 'banner_widget_model.dart';

class BannerWidgetWidget extends StatefulWidget {
  const BannerWidgetWidget({
    super.key,
    int? position,
  }) : this.position = position ?? 0;

  final int position;

  @override
  State<BannerWidgetWidget> createState() => _BannerWidgetWidgetState();
}

class _BannerWidgetWidgetState extends State<BannerWidgetWidget> {
  late BannerWidgetModel _model;
  Future<List<BannersRow>>? _bannersFuture;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BannerWidgetModel());

    _bannersFuture = BannersTable().queryRows(
      queryFn: (q) => q
          .eqOrNull(
            'position',
            widget.position,
          )
          .eqOrNull(
            'status',
            true,
          )
          .containsOrNull(
            'device',
            '{${'empresa'}}',
          ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BannersRow>>(
      future: _bannersFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 15.0),
            child: Shimmer.fromColors(
              baseColor: FlutterFlowTheme.of(context).alternate,
              highlightColor:
                  FlutterFlowTheme.of(context).alternate.withValues(alpha: 0.4),
              child: Container(
                width: double.infinity,
                height: 120.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).alternate,
                  borderRadius: BorderRadius.circular(9.0),
                ),
              ),
            ),
          );
        }
        List<BannersRow> containerBannersRowList = snapshot.data!;

        if (containerBannersRowList.isEmpty) {
          return SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
              12.0, 0.0, 12.0, 15.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.0),
            ),
            child: Builder(
              builder: (context) {
                final banner = containerBannersRowList.toList();

                return Container(
                  width: double.infinity,
                  height: 120.0,
                  child: CarouselSlider.builder(
                    itemCount: banner.length,
                    itemBuilder: (context, bannerIndex, _) {
                      final bannerItem = banner[bannerIndex];
                      return InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          logFirebaseEvent(
                              'BANNER_WIDGET_COMP_Image_1s237imi_ON_TAP');
                          logFirebaseEvent('Image_launch_u_r_l');
                          if (bannerItem.url != null &&
                              bannerItem.url!.isNotEmpty) {
                            await launchURL(bannerItem.url!);
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9.0),
                          child: CachedNetworkImage(
                            fadeInDuration: Duration(milliseconds: 500),
                            fadeOutDuration: Duration(milliseconds: 500),
                            imageUrl: valueOrDefault<String>(
                              bannerItem.image,
                              'https://images.unsplash.com/photo-1519389950473-47ba0277781c',
                            ),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    carouselController: _model.carouselController ??=
                        CarouselSliderController(),
                    options: CarouselOptions(
                      initialPage: max(0, min(1, banner.length - 1)),
                      viewportFraction: 1.0,
                      disableCenter: true,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.25,
                      enableInfiniteScroll: true,
                      scrollDirection: Axis.horizontal,
                      autoPlay: false,
                      onPageChanged: (index, _) =>
                          _model.carouselCurrentIndex = index,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
