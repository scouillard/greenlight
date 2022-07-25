import React from 'react';
import { Container } from 'react-bootstrap';
import { Outlet } from 'react-router-dom';
import { Toaster } from 'react-hot-toast';
import Header from './components/shared/Header';
import { useAuth } from './contexts/auth/AuthProvider';
import Footer from './components/shared/Footer';
import useSiteSettings from './hooks/queries/admin/site_settings/useSiteSettings';

export default function App() {
  const currentUser = useAuth();
  const containerHeight = currentUser?.signed_in ? 'full-height' : 'h-100';
  const { data: siteSettings } = useSiteSettings();

  document.documentElement.style.setProperty('--brand-color', siteSettings?.PrimaryColor);

  return (
    <>
      {currentUser?.signed_in && <Header /> }
      <Container className={containerHeight}>
        <Outlet />
      </Container>
      <Toaster
        position="bottom-right"
      />
      <Footer />
    </>
  );
}
