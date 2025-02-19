import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../data/datasources/ip_remote_data_source.dart';
import '../../data/datasources/user_ip_remote_data_source.dart';
import '../../data/repositories/ip_repository_impl.dart';
import '../../data/repositories/user_ip_repository_impl.dart';
import '../../domain/entities/ip_info.dart';

class IpQueryPage extends StatefulWidget {
  const IpQueryPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IpQueryPageState createState() => _IpQueryPageState();
}

class _IpQueryPageState extends State<IpQueryPage> with SingleTickerProviderStateMixin {
  final _ipController = TextEditingController();
  IpInfo? _ipInfo;
  bool _isLoading = false;
  String? _error;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  Future<void> _queryIp() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final dataSource = IpRemoteDataSourceImpl(client: http.Client());
      final repository = IpRepositoryImpl(remoteDataSource: dataSource);
      final result = await repository.getIpInfo(_ipController.text);

      setState(() {
        _ipInfo = result;
        _isLoading = false;
        _animationController.reset();
        _animationController.forward();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SEARCH IP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  final dataSource = UserIpRemoteDataSourceImpl(client: http.Client());
                  final repository = UserIpRepositoryImpl(remoteDataSource: dataSource);
                  final userIp = await repository.getUserIp();
                  setState(() {
                    _ipController.text = userIp;
                  });
                } catch (e) {
                  setState(() {
                    _error = 'Failed to fetch your IP address';
                  });
                }
              },
              icon: const Icon(Icons.my_location, color: Colors.white,),
              label: const Text('Get My IP'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 3,
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _ipController,
              decoration: InputDecoration(
                labelText: 'Enter IP Address',
                hintText: 'e.g. 1.1.1.1',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _queryIp,
                ),
              ),
              onSubmitted: (_) => _queryIp(),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                color: Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (_ipInfo != null)
              Expanded(
                child: SingleChildScrollView(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Card(
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('IP', _ipInfo!.ip),
                          _buildInfoRow('City', _ipInfo!.city),
                          _buildInfoRow('Region', _ipInfo!.region),
                          _buildInfoRow('Country', _ipInfo!.country),
                          _buildInfoRow('Location', _ipInfo!.loc),
                          _buildInfoRow('Organization', _ipInfo!.org),
                          _buildInfoRow('Postal', _ipInfo!.postal),
                          _buildInfoRow('Timezone', _ipInfo!.timezone),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          
        ),
          ),
        ],
      ))));
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ipController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}